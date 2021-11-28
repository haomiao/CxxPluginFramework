set CxxPluginFramework_version=1.0.0

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64

set path=%path%

cd %~dp0

set shadowdir=build
if not exist %shadowdir% (
    mkdir %shadowdir%
)
cd %~dp0%shadowdir%

cmake.exe -G "Visual Studio 16 2019" -A x64 -DCMAKE_GENERATOR_TOOLSET=v142 -DCMAKE_SYSTEM_VERSION=10.0.18362.0 -DCMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION=10.0.18362.0 -DCMAKE_VS_EFFECTIVE_PLATFORMS=Win32;x64 ..\

devenv CxxPluginFramework.sln /Rebuild "Debug|x64" /Project "ALL_BUILD.vcxproj"
devenv CxxPluginFramework.sln /Rebuild "Release|x64" /Project "ALL_BUILD.vcxproj"

cd %~dp0

robocopy %~dp0\bin\Debug\sdk %~dp0\package\pdb\Debug *.pdb /S /IS
robocopy %~dp0\bin\Release\sdk %~dp0\package\pdb\Release *.pdb /S /IS
7z.exe a -t7z "%~dp0\package\pdb.7z" "%~dp0\package\pdb"

del /f /s /q %~dp0\bin\Debug\sdk\*.pdb
del /f /s /q %~dp0\bin\Debug\sdk\*.exp
del /f /s /q %~dp0\bin\Debug\sdk\*.ilk
del /f /s /q %~dp0\bin\Debug\sdk\*.lib

del /f /s /q %~dp0\bin\Release\sdk\*.pdb
del /f /s /q %~dp0\bin\Release\sdk\*.exp
del /f /s /q %~dp0\bin\Release\sdk\*.ilk
del /f /s /q %~dp0\bin\Release\sdk\*.lib

set outputdir=package\PluginFramework
if not exist %outputdir% (
    mkdir %outputdir%
)

robocopy %~dp0\core\include %~dp0%outputdir%\include /S /IS
robocopy %~dp0\bin\Debug\sdk %~dp0%outputdir%\bin\Debug /S /IS
robocopy %~dp0\bin\Release\sdk %~dp0%outputdir%\bin\Release /S /IS

7z.exe a -t7z "%~dp0\package\PluginFramework.7z" "%~dp0%outputdir%"

echo version=%CxxPluginFramework_version% >> %~dp0\package\version.info

rmdir /S /Q %~dp0\package\pdb
rmdir /S /Q %~dp0\package\PluginFramework