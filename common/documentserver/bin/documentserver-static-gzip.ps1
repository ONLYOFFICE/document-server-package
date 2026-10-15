param(
    [switch]$NoRestartService
)

$ErrorActionPreference = "Stop"

$ServiceName = "DsProxySvc"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BaseDir = Split-Path -Parent $ScriptDir
$ConfigPath = Join-Path $BaseDir "nginx\conf\includes\ds-docservice.conf"

$StaticDirs = @("sdkjs", "web-apps", "sdkjs-plugins", "dictionaries")
$StaticExts = @(".js", ".json", ".htm", ".html", ".css", ".bin", ".wasm", ".dic", ".aff", ".svg")

function Compress-Gzip {
    param([string]$Path)

    $Source = (Resolve-Path $Path).Path
    $Target = "$Source.gz"

    Write-Host "Compress: $Source"

    $InputStream = [System.IO.File]::OpenRead($Source)
    $OutputStream = [System.IO.File]::Create($Target)

    try {
        $GzipStream = [System.IO.Compression.GZipStream]::new(
            $OutputStream,
            [System.IO.Compression.CompressionLevel]::Optimal
        )

        try {
            $InputStream.CopyTo($GzipStream)
        }
        finally {
            $GzipStream.Dispose()
        }
    }
    finally {
        $InputStream.Dispose()
        $OutputStream.Dispose()
    }
}

Set-Location $BaseDir

Write-Host "Base directory: $BaseDir"

foreach ($Dir in $StaticDirs) {
    $FullDir = Join-Path $BaseDir $Dir

    if (-not (Test-Path $FullDir)) {
        Write-Host "Skip: $FullDir not found"
        continue
    }

    Get-ChildItem $FullDir -Recurse -File |
        Where-Object { $StaticExts -contains $_.Extension.ToLower() } |
        ForEach-Object { Compress-Gzip $_.FullName }
}

$FontsDir = Join-Path $BaseDir "fonts"

if (Test-Path $FontsDir) {
    Get-ChildItem $FontsDir -Recurse -File |
        Where-Object { $_.Name -notlike "*.*" } |
        ForEach-Object { Compress-Gzip $_.FullName }
} else {
    Write-Host "Skip: $FontsDir not found"
}

if (-not (Test-Path $ConfigPath)) {
    throw "Nginx config not found: $ConfigPath"
}

Write-Host "Enable gzip_static in: $ConfigPath"

$Content = [System.IO.File]::ReadAllText($ConfigPath)
$Pattern = '(?m)^(\s*)#?\s*gzip_static\s+.*;'

if ($Content -notmatch $Pattern) {
    throw "gzip_static directive not found in config"
}

$Content = $Content -replace $Pattern, '${1}gzip_static on;'

# Convert line endings to Windows CRLF
$Content = $Content -replace "`r?`n", "`r`n"

# Save as UTF-8 without BOM
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($ConfigPath, $Content, $Utf8NoBom)

if (-not $NoRestartService) {
    Write-Host "Restart service: $ServiceName"

    if (-not (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue)) {
        throw "Service not found: $ServiceName"
    }

    Restart-Service -Name $ServiceName -Force
} else {
    Write-Host "Skip service restart"
}

Write-Host "Done"
