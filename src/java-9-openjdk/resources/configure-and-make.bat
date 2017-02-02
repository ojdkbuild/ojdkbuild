@echo off
rem Copyright 2017, akashche at redhat.com
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

rem reset env
set VS=
set WINSDK=
set WINDOWSSDKDIR=
set VS100COMNTOOLS=
set Configuration=
set WindowsSDKVersionOverride=
set ToolsVersion=
set TARGET_CPU=
set CURRENT_CPU=
set PlatformToolset=
set TARGET_PLATFORM=
set LIB=
set LIBPATH=
set INCLUDE=
set WINLD=
set MT=
set RC=
set WINAR=
set DUMPBIN=


rem set path
set PATH=${OJDKBUILD_DIR}/tools/cygwin64/bin;
set PATH=%PATH%;${OJDKBUILD_DIR}/tools/bootjdk8/bin
set PATH=%PATH%;${OJDKBUILD_DIR}/tools/toolchain/vs2013e/VC/bin
set PATH=%PATH%;${OJDKBUILD_DIR}/tools/cmake/bin
set PATH=%PATH%;${OJDKBUILD_DIR}/resources/scripts
set PATH=%PATH%;%WINDIR%/System32

rem other variables
set CYGWIN=nodosfilewarning

rem run configure and make
if not exist "${CMAKE_CURRENT_BINARY_DIR}/java-9-openjdk" (
    mkdir "${CMAKE_CURRENT_BINARY_DIR}/java-9-openjdk" || exit /b 1
    pushd "${CMAKE_CURRENT_BINARY_DIR}/java-9-openjdk" || exit /b 1
    bash "${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.sh"
    if 0 neq %ERRORLEVEL% exit /b 1
) else (
    pushd "${CMAKE_CURRENT_BINARY_DIR}/java-9-openjdk" || exit /b 1
    if "OFF" == "${${PROJECT_NAME}_DEV_MODE}" (
        echo "WARNING: jdk build directory already exist, build skipped"
    )
)

if "ON" == "${${PROJECT_NAME}_DEV_MODE}" (
    bash
)

popd || exit /b 1

