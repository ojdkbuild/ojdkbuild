@echo off

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set OJDKBUILD_DIR=%SCRIPT_DIR%

cmd /k "%OJDKBUILD_DIR%/resources/scripts/set-compile-env.bat"