@echo off
rem Copyright 2016, akashche at redhat.com
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

@echo on

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set OJDKBUILD_DIR=%SCRIPT_DIR%/../..

rem set jdk compile env
call "%SCRIPT_DIR%set-compile-env-vs10-x86_64.bat"

rem ojfx env
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/ant182/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/gradle18/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/cygwin64/bin
set DXSDK_DIR=%OJDKBUILD_DIR%/tools/toolchain/directx-june2010
set BASECLASSES_SDK_DIR=%WINDOWSSDKDIR%
set MSVCR100_DIR=%OJDKBUILD_DIR%/tools/toolchain/msvcr100/amd64