$ErrorActionPreference = 'Stop'

if (Get-Command ubuntu2204.exe -ErrorAction SilentlyContinue) {
    & wsl.exe --unregister "Ubuntu-22.04"
}
else {
    & wsl.exe --unregister "Ubuntu"
}
& wsl.exe --list --verbose
