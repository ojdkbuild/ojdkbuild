@echo off

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set OJDKBUILD_DIR=%SCRIPT_DIR%

call "%OJDKBUILD_DIR%/resources/scripts/set-compile-env.bat"
@echo off
if 0 neq %ERRORLEVEL% exit /b 1

rmdir /s /q build
if exist build exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1

cmake "%OJDKBUILD_DIR%/src/java-1.8.0-openjdk" -G "NMake Makefiles" || exit /b 1
nmake openjdk || exit /b 1

popd || exit /b 1
echo OJDKBUILD_FINISH_SUCCESS
