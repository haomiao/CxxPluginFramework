cd %~dp0
set shadowdir=build
if not exist %shadowdir% (
    mkdir %shadowdir%
)
cd %~dp0%shadowdir%

cmake.exe -G "Visual Studio 16 2019" -A Win32 -DCMAKE_GENERATOR_TOOLSET=v142 -DCMAKE_SYSTEM_VERSION=10.0.18362.0 -DCMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION=10.0.18362.0 -DCMAKE_VS_EFFECTIVE_PLATFORMS=Win32;x64  ..\

cd %~dp0
