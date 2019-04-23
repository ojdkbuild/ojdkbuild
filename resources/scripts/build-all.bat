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

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set OJDKBUILD_DIR=%SCRIPT_DIR%../..
set GIT_HOME=C:/Program Files/Git

rem clean destination
rmdir /s /q "%OJDKBUILD_DIR%/dist"
if exist "%OJDKBUILD_DIR%/dist" exit /b 1
mkdir "%OJDKBUILD_DIR%/dist" || exit /b 1

rem jdk8_x86_64
call "%OJDKBUILD_DIR%/resources/scripts/set-compile-env-vs10-x86_64.bat"
if errorlevel 1 exit /b 1
@echo off
rem release
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/openjfx-8u" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf || exit /b 1
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-1.8.0-openjdk" ^
        -Dopenjdk_ENABLE_BOOTCYCLE=ON ^
        -Dopenjdk_ENABLE_OPENJFX=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake installer || exit /b 1
popd || exit /b 1
rem debug
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/openjfx-8u" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf || exit /b 1
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-1.8.0-openjdk" ^
        -DCMAKE_BUILD_TYPE=Debug ^
        -G "NMake Makefiles" || exit /b 1
nmake zip_debug || exit /b 1
popd || exit /b 1

rem jdk8_x86
call "%OJDKBUILD_DIR%/resources/scripts/set-compile-env-vs10-x86.bat"
if errorlevel 1 exit /b 1
@echo off
rem release
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/openjfx-8u" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf || exit /b 1
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-1.8.0-openjdk" ^
        -Dopenjdk_ENABLE_BOOTCYCLE=ON ^
        -Dopenjdk_ENABLE_32_BIT=ON ^
        -Dopenjdk_ENABLE_OPENJFX=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake installer || exit /b 1
popd || exit /b 1
rem debug
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/openjfx-8u" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf || exit /b 1
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-1.8.0-openjdk" ^
        -DCMAKE_BUILD_TYPE=Debug ^
        -Dopenjdk_ENABLE_32_BIT=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake zip_debug || exit /b 1
popd || exit /b 1

rem jdk11_x86_64
call "%OJDKBUILD_DIR%/resources/scripts/set-compile-env-vs15-x86_64.bat"
if errorlevel 1 exit /b 1
@echo off
rem release
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/jmc" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf rem || exit /b 1 : long paths
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-11-openjdk" ^
        -Dopenjdk_ENABLE_BOOTCYCLE=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake installer || exit /b 1
popd || exit /b 1
rem debug
rmdir /s /q build
if exist build exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-11-openjdk" ^
        -DCMAKE_BUILD_TYPE=Debug ^
        -G "NMake Makefiles" || exit /b 1
nmake zip_debug || exit /b 1
popd || exit /b 1

rem jdk12_x86_64
call "%OJDKBUILD_DIR%/resources/scripts/set-compile-env-vs15-x86_64.bat"
if errorlevel 1 exit /b 1
@echo off
rem release
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/jmc" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf rem || exit /b 1 : long paths
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-12-openjdk" ^
        -Dopenjdk_ENABLE_BOOTCYCLE=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake installer || exit /b 1
popd || exit /b 1
rem debug
rmdir /s /q build
if exist build exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-12-openjdk" ^
        -DCMAKE_BUILD_TYPE=Debug ^
        -G "NMake Makefiles" || exit /b 1
nmake zip_debug || exit /b 1
popd || exit /b 1

echo OJDKBUILD_FINISH_SUCCESS
