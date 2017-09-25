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

rem tools dirs
set VS=%OJDKBUILD_DIR%/tools/toolchain/vs2013e
set WINSDK=%VS%/8.1

rem set compiler environment manually
set VCINSTALLDIR=%VS%\VC\
set VisualStudioVersion=12.0
set VS120COMNTOOLS=
set VSINSTALLDIR=%VS%
set WindowsSdkDir=%WINSDK%

set LIB=%VS%/VC/Lib;%WINSDK%/Lib/x86
set LIBPATH=%VS%/VC/Lib
set INCLUDE=%VS%/VC/INCLUDE;%WINSDK%/include/um;%WINSDK%/include/shared

rem set path
set PATH=%VS%/VC/Bin
set PATH=%PATH%;%WINSDK%/Bin/x86;C:/WINDOWS/System32;C:/WINDOWS;C:/WINDOWS/System32/wbem
set PATH=%PATH%;%VS%/VC/redist/x86/Microsoft.VC120.CRT/msvcr120.dll
set PATH=%PATH%;%VS%/VC/redist/x86/Microsoft.VC120.CRT/msvcp120.dll
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/cmake/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/pkgconfig/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/resources/scripts
