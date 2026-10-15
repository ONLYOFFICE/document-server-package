$wacs_cmd = Get-Command wacs -ErrorAction SilentlyContinue

if (-not $wacs_cmd) {
  Write-Output " Attention! Win-Acme (wacs) is not installed or not in PATH. "
  Write-Output " Add wacs.exe to PATH or run script with full path to wacs.exe. "
  exit
}

$wacs_path = $wacs_cmd.Source

function Assert-ValidDomain {
  param([Parameter(Mandatory)][string]$Domain)
  if ($Domain -notmatch '^([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}$') {
    throw "Bad DOMAIN: $Domain"
  }
}

function Assert-ValidEmailList {
  param([Parameter(Mandatory)][string]$EmailList)
  $pattern = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,63}$'
  $emails = $EmailList -split '\s*,\s*' | Where-Object { $_ -and $_.Trim().Length -gt 0 }
  if ($emails.Count -lt 1) { throw "Bad EMAIL list: empty" }
  foreach ($e in $emails) {
    if ($e -notmatch $pattern) { throw "Bad EMAIL in list: $e" }
  }
}

if ( $args.Count -ge 2 )
{
  $app = Split-Path -Parent $PSScriptRoot
  $root_dir = "$env:ProgramData\ONLYOFFICE\letsencrypt"
  $nginx_conf_dir = "${app}\nginx\conf"
  $nginx_conf = "ds.conf"
  $nginx_tmpl = "ds-ssl.conf.tmpl"
  $proxy_service = "DsProxySvc"

  $letsencrypt_domain = $args[1]
  $letsencrypt_mail = $args[0]

  Assert-ValidDomain -Domain $letsencrypt_domain
  Assert-ValidEmailList -EmailList $letsencrypt_mail

  [void](New-Item -ItemType "directory" -Path "${root_dir}\Logs" -Force)

  "wacs --target manual --host ${letsencrypt_domain} --validation filesystem --webroot `"${root_dir}`" --store pemfiles --pemfilespath `"${root_dir}`" --pemfilesname ${letsencrypt_domain} --installation none --emailaddress ${letsencrypt_mail} --accepttos --closeonfinish --notaskscheduler" > "${root_dir}\Logs\le-start.log"
  & $wacs_path --target manual --host ${letsencrypt_domain} --validation filesystem --webroot ${root_dir} --store pemfiles --pemfilespath ${root_dir} --pemfilesname ${letsencrypt_domain} --installation none --emailaddress ${letsencrypt_mail} --accepttos --closeonfinish --notaskscheduler *>> "${root_dir}\Logs\le-new.log"

  pushd "${root_dir}"
    $certFile = Get-ChildItem $root_dir -File | ? { $_.Name -match "^$letsencrypt_domain.*(fullchain|chain)\.pem$" -and $_.Name -notmatch "chain-only" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $keyFile = Get-ChildItem $root_dir -File | ? { $_.Name -match "^$letsencrypt_domain.*(key|privkey)\.pem$" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $certFile -or -not $keyFile) {
      throw "PEM files were not found in '$root_dir'. Check logs: $root_dir\Logs\le-new.log"
    }

    $ssl_cert = $certFile.FullName.Replace('\','/')
    $ssl_key  = $keyFile.FullName.Replace('\','/')
  popd

  if ( [System.IO.File]::Exists($ssl_cert) -and [System.IO.File]::Exists($ssl_key) -and [System.IO.File]::Exists("${nginx_conf_dir}\${nginx_tmpl}"))
  {
    $secure_link_secret = (Select-String -Path "${nginx_conf_dir}\${nginx_conf}" -Pattern "secure_link_secret (.*)").Matches.Groups[1].Value
    Copy-Item "${nginx_conf_dir}\${nginx_tmpl}" -Destination "${nginx_conf_dir}\${nginx_conf}"
    ((Get-Content -Path "${nginx_conf_dir}\${nginx_conf}" -Raw) -replace 'secure_link_secret (.*)', "secure_link_secret $secure_link_secret") | Set-Content -Path "${nginx_conf_dir}\${nginx_conf}"
    ((Get-Content -Path "${nginx_conf_dir}\${nginx_conf}" -Raw) -replace '{{SSL_CERTIFICATE_PATH}}', $ssl_cert) | Set-Content -Path "${nginx_conf_dir}\${nginx_conf}"
    ((Get-Content -Path "${nginx_conf_dir}\${nginx_conf}" -Raw) -replace '{{SSL_KEY_PATH}}', $ssl_key) | Set-Content -Path "${nginx_conf_dir}\${nginx_conf}"
  }

  Restart-Service -Name $proxy_service

  @(
    "`"$wacs_path`" --renew --baseuri `"https://acme-v02.api.letsencrypt.org/`" >> `"$root_dir\Logs\le-renew.log`" 2>&1",
    "net stop $proxy_service",
    "net start $proxy_service"
  ) | Set-Content -Path "$root_dir\letsencrypt_cron.bat" -Encoding ascii

  $day = (Get-Date).DayOfWeek.ToString().ToUpperInvariant().SubString(0, 3)
  $time = Get-Date -Format "HH:mm"
  & "$env:SystemRoot\System32\schtasks.exe" /F /CREATE /SC WEEKLY /D $day /TN "Win-Acme renew" /TR "$root_dir\letsencrypt_cron.bat" /ST $time 2>&1
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Unable to create the 'Win-Acme renew' scheduled task (SCHTASKS exit code: $LASTEXITCODE). Automatic certificate renewal will not run; please create the task manually."
  }
}
elseif ($args[0] -eq "-d" -or $args[0] -eq "--default") {
  $app = Split-Path -Parent $PSScriptRoot
  $nginx_conf_dir = "${app}\nginx\conf"
  $config = "${nginx_conf_dir}\ds.conf"
  $secure_link_secret = (Select-String -Path $config -Pattern 'secure_link_secret (.*)' | Select-Object -First 1).Matches.Groups[1].Value
  Copy-Item "${nginx_conf_dir}\ds.conf.tmpl" -Destination $config
  ((Get-Content -Path $config -Raw) -replace 'secure_link_secret (.*)', "secure_link_secret $secure_link_secret") | Set-Content -Path $config
  Restart-Service -Name "DsProxySvc"
  Write-Output "Returned to the default proxy configuration."
}
else
{
  Write-Output " This script provided to automatically get Let's Encrypt SSL Certificates for Document Server "
  Write-Output " usage: "
  Write-Output "   documentserver-letsencrypt.ps1 EMAIL DOMAIN "
  Write-Output "      EMAIL       Email used for registration and recovery contact. Use "
  Write-Output "                  comma to register multiple emails, ex: "
  Write-Output "                  u1@example.com,u2@example.com. "
  Write-Output "      DOMAIN      Domain name to apply "
  Write-Output " "
  Write-Output " Return to the default HTTP proxy configuration: "
  Write-Output "   documentserver-letsencrypt.ps1 -d | --default "
  Write-Output " Certificates and automatic renewal settings are preserved. "
}
