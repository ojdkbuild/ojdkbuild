@echo off
rem Copyright 2021, akashche at redhat.com
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
set VSINSTALLDIR=%OJDKBUILD_DIR%/tools/toolchain/vs2019bt_16113/
set VS160COMNTOOLS=%OJDKBUILD_DIR%/tools/toolchain/vs2019bt_16113/Common7/Tools/
set WindowsSdkDir=%OJDKBUILD_DIR%/tools/toolchain/sdk10_19041/
set INCLUDE=%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/include;%WindowsSdkDir%/include/10.0.19041.0/ucrt
set INCLUDE=%INCLUDE%;%WindowsSdkDir%/include/10.0.19041.0/shared;%WindowsSdkDir%/include/10.0.19041.0/um
set INCLUDE=%INCLUDE%;%WindowsSdkDir%/include/10.0.19041.0/winrt;%WindowsSdkDir%/include/10.0.19041.0/cppwinrt
set LIB=%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/lib/x64;%WindowsSdkDir%/lib/10.0.19041.0/ucrt/x64;%WindowsSdkDir%/lib/10.0.19041.0/um/x64
set LIBPATH=%WindowsSdkDir%/UnionMetadata/10.0.19041.0;%WindowsSdkDir%/References/10.0.19041.0

rem set path
set PATH=%OJDKBUILD_DIR%/tools/cygwin_jdk11/bin/path_prepend
set PATH=%PATH%;%WindowsSdkDir%/bin/10.0.19041.0/x64;%WindowsSdkDir%/bin/x64;%WindowsSdkDir%/bin/10.0.19041.0/x86
set PATH=%PATH%;%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64

set PATH=%PATH%;%OJDKBUILD_DIR%/tools/cmake/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/pkgconfig/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/cygwin_jdk11/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/maven/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/resources/scripts
set PATH=%PATH%;C:/Windows/system32;C:/Windows;C:/Windows/System32/Wbem
