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

rem set path
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/make
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/cygwin/bin
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/bootjdk7/bin
rem prepend
set PATH=${CMAKE_CURRENT_LIST_DIR}/../../tools/cygwin/bin/path_prepend;%PATH%

rem pkg-config
set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%;${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig

rem clear VERBOSE var as it conflicts with LOG var
set VERBOSE=

rem define this to walkaround too strict configure check
set OBJCOPY=NOT_NEEDED_ON_WINDOWS

rem other variables
set CYGWIN=nodosfilewarning

rem run configure and make
if not exist "${CMAKE_CURRENT_BINARY_DIR}/java-1.8.0-openjdk" (
    mkdir "${CMAKE_CURRENT_BINARY_DIR}/java-1.8.0-openjdk" || exit /b 1
    pushd "${CMAKE_CURRENT_BINARY_DIR}/java-1.8.0-openjdk" || exit /b 1
    bash "${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.sh"
    if 0 neq %ERRORLEVEL% exit /b 1
) else (
    pushd "${CMAKE_CURRENT_BINARY_DIR}/java-1.8.0-openjdk" || exit /b 1
    if "OFF" == "${${PROJECT_NAME}_DEV_MODE}" (
        echo "ERROR: jdk build directory already exist, please delete it first or run build in development mode"
        exit /b 1
    )
)

if "ON" == "${${PROJECT_NAME}_DEV_MODE}" (
    bash
)

popd || exit /b 1
