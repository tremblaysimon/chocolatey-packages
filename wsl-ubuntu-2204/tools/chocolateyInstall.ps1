$ErrorActionPreference = 'Stop'

$installRoot = $false

$pp = Get-PackageParameters
if ([bool]$pp.InstallRoot -eq $true) { $installRoot = $pp.InstallRoot }

$packageArgs = @{
    packageName    = 'wsl-ubuntu-2204'
    softwareName   = 'Ubuntu 22.04 LTS for WSL'
    checksum       = 'c5028547edfe72be8f7d44ef52cee5aacaf9b1ae1ed4f7e39b94dae3cf286bc2'
    checksumType   = 'sha256'
    url            = 'https://aka.ms/wslubuntu2204'
    fileFullPath   = "$env:TEMP\ubuntu2204.appx"
    validExitCodes = @(0)
}

$wslIntalled = $false
if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    $wslIntalled = $true
}

if (!$wslIntalled) {
    Write-Error "WSL not detected! WSL is needed to install $($packageArgs.softwareName)"
    exit 1
}

Get-ChocolateyWebFile @packageArgs

Add-AppxPackage $packageArgs.fileFullPath

if ($installRoot) {
    if (Get-Command ubuntu2204.exe -ErrorAction SilentlyContinue) {
        & ubuntu2204.exe install --root
    }
    else {
        & ubuntu.exe install --root
    }
    & wsl.exe --list --verbose
}
