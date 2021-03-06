# Ubuntu 22.04

*"Ubuntu 22.04 LTS on Windows allows you to use Ubuntu Terminal and run Ubuntu command line utilities including bash, ssh, git, apt and many more."* - <https://www.microsoft.com/en-us/p/ubuntu-2204-lts/9PN20MSR04DW>

## Package parameters

- `/InstallRoot:true` - whether to set the default user as `root`. Defaults to `false`

Example: `choco install wsl-ubuntu-2204 --params "/InstallRoot:true"`

## Note

- This package checks to see if WSL is installed before downloading the distro archive file. If this check fails, the install will fail.
- **Important:** Install [wsl](https://chocolatey.org/packages/wsl) or [wsl2](https://chocolatey.org/packages/wsl2) then restart before attempting to install this package. A dependency was not declared since installing this package on a system where WSL wasn't installed before will always fail since WSL requires a restart before it can be used.
