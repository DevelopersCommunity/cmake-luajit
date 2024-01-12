$ErrorActionPreference = 'Stop'

# https://github.com/microsoft/vswhere/wiki/Start-Developer-Command-Prompt#using-powershell
function Start-VsDevCmd
{
    $installationPath = (
        & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" `
            -prerelease -latest -property installationPath)
    $vsdevcmd = Join-Path `
        -Path "$installationPath" `
        -ChildPath Common7\Tools\VsDevCmd.bat `
        -Resolve
    & "${env:COMSPEC}" /s /c "`"$vsdevcmd`" -no_logo -arch=amd64 && set" |
        ForEach-Object {
            $name, $value = $_ -split '=', 2
            Set-Content env:\"$name" $value
        }
}

if (-Not (Get-Command "cl" -ErrorAction "SilentlyContinue"))
{
    Start-VsDevCmd
}
if (Test-Path -Path build -PathType Container)
{
    Remove-Item -Recurse -Force -Path build
}
cmake -B build -G Ninja -D CMAKE_C_COMPILER=cl
cmake --build build --target package
