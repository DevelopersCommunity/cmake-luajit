# LuaJIT installer for Windows

This is a CMake-based project to package [LuaJIT](https://luajit.org/) and
[LuaRocks](https://luarocks.org/).

## Build prerequisites

- [Microsoft Visual
  C++](https://learn.microsoft.com/cpp/overview/visual-cpp-in-visual-studio)
- [CMake](https://cmake.org/)
- [WiX v3](https://wixtoolset.org/docs/wix3/)

You can install the first two components with the following
[winget](https://learn.microsoft.com/windows/package-manager/winget/) commands:

```powershell
winget install --id Microsoft.VisualStudio.2022.Community
winget install --id Kitware.CMake
```

After installing Visual Studio, open `Visual Studio Installer` and ensure that
the "Desktop Development with C++" workload is installed.

WiX v3 is available at <https://github.com/wixtoolset/wix3/releases/>. It
requires .NET Framework 3.5, which can be installed with the following command:

```powershell
Start-Process `
    -FilePath pwsh `
    -ArgumentList "-Command `"& {Enable-WindowsOptionalFeature -Online -FeatureName NetFx3}`"" `
    -Wait `
    -Verb RunAs
```

## Build

Use the [Build-LuaJIT.ps1](./Build-LuaJIT.ps1) script to generate the
installation package in both ZIP and MSI formats.

If successful, the ZIP and MSI files will be available in the `build` directory.
