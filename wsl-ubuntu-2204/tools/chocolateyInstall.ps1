$ErrorActionPreference = 'Stop'

$automaticInstall = $false

$packageParameters = Get-PackageParameters
if ([bool]$packageParameters.AutomaticInstall -eq $true) { 
    $automaticInstall = $packageParameters.AutomaticInstall 
}

$packageArgs = @{
    packageName    = 'wsl-ubuntu-2204'
    softwareName   = 'Ubuntu 22.04 LTS for WSL'
    checksum       = '6ad6d88763451a50f98f2469ce80464d666204c08d07f8f6a89e0d5ca05b097a'
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

if ($automaticInstall) {
    $wslName = 'devbox'
    $wslInstallationPath = "$env:USERPROFILE\WSL2\$wslName"
    $wslUsername = $env:USERNAME.ToLower().Replace(' ', '')

    # create staging directory if it does not exists
    if (-Not (Test-Path -Path $env:TEMP\staging)) { $dir = mkdir $env:TEMP\staging }

    Move-Item $env:TEMP\ubuntu2204.appx $env:TEMP\staging\$wslName-Temp.zip

    Expand-Archive $env:TEMP\staging\$wslName-Temp.zip $env:TEMP\staging\$wslName-Temp

    Move-Item $env:TEMP\staging\$wslName-Temp\Ubuntu_2204.0.10.0_x64.appx $env:TEMP\staging\$wslName.zip

    Expand-Archive $env:TEMP\staging\$wslName.zip $env:TEMP\staging\$wslName

    if (-Not (Test-Path -Path $wslInstallationPath)) {
        mkdir $wslInstallationPath
    }
    wsl --import $wslName $wslInstallationPath $env:TEMP\staging\$wslName\install.tar.gz

    Move-Item $env:TEMP\staging\$wslName-Temp.zip $env:TEMP\ubuntu2204.appx 
    Remove-Item -r $env:TEMP\staging\


    $chocolateyInstallFolder = $env:ChocolateyInstall.Replace('\', '/')
    $chocolateyInstallFolder = $chocolateyInstallFolder.Replace("C:", "/mnt/c")

    # create your user and add it to sudoers
    wsl -d $wslName -u root bash -ic "$chocolateyInstallFolder/lib/wsl-ubuntu-2204/tools/scripts/createUser.sh $wslUsername ubuntu"

    # ensure WSL Distro is restarted when first used with user account
    wsl -t $wslName
}
else {
    Add-AppxPackage $packageArgs.fileFullPath
}
