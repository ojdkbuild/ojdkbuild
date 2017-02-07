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

set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set OJDKBUILD_DIR=%SCRIPT_DIR%../..

set prof=%OJDKBUILD_DIR%/resources/profiles/jdk8_zip.gitmodules.txt

if not "" == "%1" set prof=%1

echo Fetching submodules using profile: [%prof%]
for /f "tokens=*" %%A in  ( %prof% ) do (
    pushd "%OJDKBUILD_DIR%" || exit /b 1
    echo git submodule update --init %%A
    git submodule update --init %%A || exit /b 1
    popd || exit /b 1
)
exit /b 0
