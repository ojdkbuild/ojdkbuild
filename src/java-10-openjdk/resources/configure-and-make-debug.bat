@echo off
rem Copyright 2018, akashche at redhat.com
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
set PATH=%PATH%;${OJDKBUILD_DIR}/tools/pkgconfig/bin
set PATH=%PATH%;${OJDKBUILD_DIR}/resources/scripts
set PATH=%PATH%;%WINDIR%/System32

rem other variables
set CYGWIN=nodosfilewarning

rem unbreak verbose logging
set VERBOSE_VALUE=%VERBOSE%
set VERBOSE=

rem pkg-config
set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%;${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig

rem bash return error flag
rem see https://support.microsoft.com/en-us/help/69576/testing-for-a-specific-error-level-in-batch-files
set ERRBASH=0

rem unpack bootjdk
if not exist "${OJDKBUILD_DIR}/tools/bootjdk9/lib/modules" (cd ${OJDKBUILD_DIR}/tools/bootjdk9/lib && ${OJDKBUILD_DIR}/tools/zip/unzip -qo modules.zip) || exit /b 1

rem run configure and make for debug
if not exist "${${PROJECT_NAME}_DEST_JDK_DIR}" (
    mkdir "${${PROJECT_NAME}_DEST_JDK_DIR}" || exit /b 1
    pushd "${${PROJECT_NAME}_DEST_JDK_DIR}" || exit /b 1
    bash "${CMAKE_CURRENT_BINARY_DIR}/configure-and-make-debug.sh"
    if errorlevel 1 set ERRBASH=1
    popd || exit /b 1
) else (
    if "OFF" == "${${PROJECT_NAME}_DEV_MODE}" (
        echo "WARNING: jdk build directory already exist, build skipped"
    )
)
if 0 neq %ERRBASH% exit /b 1

rem provide console to user in dev mode
if "ON" == "${${PROJECT_NAME}_DEV_MODE}" (
    pushd "${${PROJECT_NAME}_DEST_JDK_DIR}" || exit /b 1
    bash
    if errorlevel 1 set ERRBASH=1
    popd || exit /b 1
)
if 0 neq %ERRBASH% exit /b 1

set VERBOSE=%VERBOSE_VALUE%