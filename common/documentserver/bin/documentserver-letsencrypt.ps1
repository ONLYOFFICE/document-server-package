# runas administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{ 
  Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
  exit
}

function Test-RegistryValue($RegistryKey, $RegistryName)
{
  $exists = Get-ItemProperty -Path "$RegistryKey" -Name "$RegistryName" -ErrorAction SilentlyContinue
  if (($exists -ne $null) -and ($exists.Length -ne 0)) { return $true }
  return $false
}

$certbot_path = if ((Test-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Certbot" "InstallLocation") -eq $true )
{
  (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Certbot" -ErrorAction Stop).InstallLocation
}
elseif ((Test-RegistryValue "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Certbot" "InstallLocation") -eq $true )
{
  (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Certbot" -ErrorAction Stop).InstallLocation
}

if ( -not $certbot_path )
{
  Write-Output " Attention! Certbot is not installed on your computer. "
  Write-Output " Certbot could be downloaded by this link 'https://dl.eff.org/certbot-beta-installer-win32.exe' "
  exit
}

if ( $args.Count -ge 2 )
{
  $letsencrypt_root_dir = "$env:SystemDrive\Certbot\live"
  $app = Resolve-Path -Path ".\..\"
  $root_dir = "${app}\letsencrypt"
  $nginx_conf_dir = "${app}\nginx\conf"
  $nginx_conf = "ds.conf"
  $nginx_tmpl = "ds-ssl.conf.tmpl"
  $proxy_service = "DsProxySvc"

  $letsencrypt_domain = $args[1]
  $letsencrypt_mail = $args[0]

  [void](New-Item -ItemType "directory" -Path "${root_dir}\Logs" -Force)

  "certbot certonly --expand --webroot -w `"${root_dir}`" --noninteractive --agree-tos --email ${letsencrypt_mail} -d ${letsencrypt_domain}" > "${app}\letsencrypt\Logs\le-start.log"
  cmd.exe /c "certbot certonly --expand --webroot -w `"${root_dir}`" --noninteractive --agree-tos --email ${letsencrypt_mail} -d ${letsencrypt_domain}" > "${app}\letsencrypt\Logs\le-new.log"

  pushd "${letsencrypt_root_dir}\${letsencrypt_domain}"
    $ssl_cert = (Get-Item "${letsencrypt_root_dir}\${letsencrypt_domain}\fullchain.pem").FullName.Replace('\', '/')
    $ssl_key = (Get-Item "${letsencrypt_root_dir}\${letsencrypt_domain}\privkey.pem").FullName.Replace('\', '/')
  popd

  if ( [System.IO.File]::Exists($ssl_cert) -and [System.IO.File]::Exists($ssl_key) -and [System.IO.File]::Exists("${nginx_conf_dir}\${nginx_tmpl}"))
  {
    $secure_link_secret = (Select-String -Path "${nginx_conf_dir}\${nginx_conf}" -Pattern "secure_link_secret (.*)").Matches.Groups[1].Value
    Copy-Item "${nginx_conf_dir}\${nginx_tmpl}" -Destination "${nginx_conf_dir}\${nginx_conf}"
    ((Get-Content -Path "${nginx_conf_dir}\${nginx_conf}" -Raw) -replace 'secure_link_secret (.*)', "secure_link_secret $secure_link_secret") | Set-Content -Path "${nginx_conf_dir}\${nginx_conf}"
    ((Get-Content -Path "${nginx_conf_dir}\${nginx_conf}" -Raw) -replace '{{SSL_CERTIFICATE_PATH}}', $ssl_cert) | Set-Content -Path "${nginx_conf_dir}\${nginx_conf}"
    ((Get-Content -Path "${nginx_conf_dir}\${nginx_conf}" -Raw) -replace '{{SSL_KEY_PATH}}', $ssl_key) | Set-Content -Path "${nginx_conf_dir}\${nginx_conf}"
  }

  $acl = Get-Acl -Path "$env:SystemDrive\Certbot\archive\${letsencrypt_domain}"
  $acl.SetSecurityDescriptorSddlForm('O:LAG:S-1-5-21-4011186057-2202358572-2315966083-513D:PAI(A;;0x1200a9;;;WD)(A;;FA;;;SY)(A;OI;0x1200a9;;;LS)(A;;FA;;;BA)(A;;FA;;;LA)')
  Set-Acl -Path $acl.path -ACLObject $acl

  Restart-Service -Name $proxy_service

  @(
    "certbot renew >> `"${app}\letsencrypt\Logs\le-renew.log`"",
    "net stop $proxy_service",
    "net start $proxy_service"
  ) | Set-Content -Path "${app}\letsencrypt\letsencrypt_cron.bat" -Encoding ascii

  $day = (Get-Date -Format "dddd").ToUpper().SubString(0, 3)
  $time = Get-Date -Format "HH:mm"
  cmd.exe /c "SCHTASKS /F /CREATE /SC WEEKLY /D $day /TN `"Certbot renew`" /TR `"${app}\letsencrypt\letsencrypt_cron.bat`" /ST $time"
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
}
