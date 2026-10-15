Get-ChildItem "$PSScriptRoot\..\server\App_Data\cache\files\errors" -Directory -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Sort-Object FullName -Descending | Remove-Item -Recurse -Force

Get-ChildItem "$PSScriptRoot\..\Log" -Recurse -Filter *.log | Where-Object LastWriteTime -lt (Get-Date).AddDays(-30) | Remove-Item -Force

# Rename Nginx logs and reopen them without restarting the service.
$nginxDir = Join-Path $PSScriptRoot '..\nginx'
$nginxLogDir = Join-Path $nginxDir 'logs'
if (!(Test-Path -LiteralPath $nginxLogDir -PathType Container)) { return }

$logsRotated = $false
foreach ($logName in @('nginx.access.log', 'nginx.error.log')) {
    Get-ChildItem -LiteralPath $nginxLogDir -File |
        Where-Object { $_.Name -like "$logName.*" -and $_.LastWriteTime -lt (Get-Date).AddDays(-30) } |
        Remove-Item -Force

    $logPath = Join-Path $nginxLogDir $logName
    if (!(Test-Path -LiteralPath $logPath -PathType Leaf)) { continue }

    try {
        if ((Get-Item -LiteralPath $logPath -ErrorAction Stop).Length -eq 0) { continue }
        $archivePath = $logPath + '.' + (Get-Date -Format 'yyyyMMdd-HHmmss-fffffff')
        Move-Item -LiteralPath $logPath -Destination $archivePath -ErrorAction Stop
        $logsRotated = $true
    } catch {
        Write-Error "Failed to rotate ${logPath}: $_"
    }
}

$nginxPidPath = Join-Path $nginxLogDir 'nginx.pid'
if (!$logsRotated -or !(Test-Path -LiteralPath $nginxPidPath -PathType Leaf)) { return }

Push-Location -LiteralPath $nginxDir -ErrorAction Stop
try {
    & '.\nginx.exe' -p "$nginxDir" -s reopen
    if ($LASTEXITCODE -ne 0) { throw "nginx -s reopen failed with exit code $LASTEXITCODE" }
} finally {
    Pop-Location
}
