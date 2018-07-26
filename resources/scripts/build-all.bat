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

rem call "%OJDKBUILD_DIR%/resources/scripts/modules.bat" "%OJDKBUILD_DIR%/resources/profiles/everything.gitmodules.txt"
rem if errorlevel 1 exit /b 1

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
        -Dopenjdk_BOOTSTRAP_BUILD=ON ^
        -Dopenjdk_ENABLE_OPENJFX=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake srcbundle VERBOSE=1 || exit /b 1
nmake installer VERBOSE=1 || exit /b 1
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
nmake zip_debug VERBOSE=1 || exit /b 1
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
        -Dopenjdk_BOOTSTRAP_BUILD=ON ^
        -Dopenjdk_32_BIT=ON ^
        -Dopenjdk_ENABLE_OPENJFX=ON ^
		-Dopenjdk_INSTALLER_PRODUCT_UUID=8dfb22cc-185d-43fe-9cc0-f8ebd38272d3 ^
		-Dopenjdk_INSTALLER_UPDATE_UUID=494948c5-a3ee-4eee-9007-2cb9a18334c9 ^
        -G "NMake Makefiles" || exit /b 1
nmake installer_without_notifier VERBOSE=1 || exit /b 1
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
        -Dopenjdk_32_BIT=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake zip_debug VERBOSE=1 || exit /b 1
popd || exit /b 1

rem jdk10_x86_64
call "%OJDKBUILD_DIR%/resources/scripts/set-compile-env-vs12-x86_64.bat"
if errorlevel 1 exit /b 1
@echo off
rem release
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/openjfx" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf || exit /b 1
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-10-openjdk" ^
        -G "NMake Makefiles" || exit /b 1
nmake srcbundle VERBOSE=1 || exit /b 1
nmake installer VERBOSE=1 || exit /b 1
popd || exit /b 1
rem debug
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/openjfx" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf || exit /b 1
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-10-openjdk" ^
        -DCMAKE_BUILD_TYPE=Debug ^
        -G "NMake Makefiles" || exit /b 1
nmake zip_debug VERBOSE=1 || exit /b 1
popd || exit /b 1

rem jdk10_x86
call "%OJDKBUILD_DIR%/resources/scripts/set-compile-env-vs12-x86.bat"
if errorlevel 1 exit /b 1
@echo off
rem release
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/openjfx" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf || exit /b 1
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-10-openjdk" ^
        -Dopenjdk_32_BIT=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake installer VERBOSE=1 || exit /b 1
popd || exit /b 1
rem debug
rmdir /s /q build
if exist build exit /b 1
pushd "upstream/openjfx" || exit /b 1
"%GIT_HOME%/bin/git.exe" clean -dxf || exit /b 1
popd || exit /b 1
mkdir build || exit /b 1
pushd build || exit /b 1
cmake "%OJDKBUILD_DIR%/src/java-10-openjdk" ^
        -DCMAKE_BUILD_TYPE=Debug ^
        -Dopenjdk_32_BIT=ON ^
        -G "NMake Makefiles" || exit /b 1
nmake zip_debug VERBOSE=1 || exit /b 1
popd || exit /b 1

echo OJDKBUILD_FINISH_SUCCESS
