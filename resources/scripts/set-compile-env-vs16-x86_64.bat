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
rem set UniversalCRTSdkDir=%WindowsSdkDir%/
rem set WindowsLibPath=%WindowsSdkDir%/UnionMetadata/10.0.19041.0;%WindowsSdkDir%/References/10.0.19041.0
rem set WindowsSdkBinPath=%WindowsSdkDir%/bin/
rem set WindowsSDKLibVersion=10.0.19041.0/
rem set WindowsSdkVerBinPath=%WindowsSdkDir%/bin/10.0.19041.0/
rem set WindowsSDKVersion=10.0.19041.0/

rem set compiler environment manually
rem set DevEnvDir=%VSINSTALLDIR%/Common7/IDE/
rem set ExtensionSdkDir=%WindowsSdkDir%/ExtensionSDKs
rem set INCLUDE=%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/include;%WindowsSdkDir%/include/10.0.19041.0/ucrt
rem set INCLUDE=%INCLUDE%;%WindowsSdkDir%/include/10.0.19041.0/shared;%WindowsSdkDir%/include/10.0.19041.0/um
rem set INCLUDE=%INCLUDE%;%WindowsSdkDir%/include/10.0.19041.0/winrt;%WindowsSdkDir%/include/10.0.19041.0/cppwinrt
rem set LIB=%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/lib/x64;%WindowsSdkDir%/lib/10.0.19041.0/ucrt/x64;%WindowsSdkDir%/lib/10.0.19041.0/um/x64
rem set LIBPATH=%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/lib/x64;%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/lib/x86/store/references
rem set LIBPATH=%LIBPATH%;%WindowsSdkDir%/UnionMetadata/10.0.19041.0;%WindowsSdkDir%/References/10.0.19041.0
rem set Platform=x64
rem set PROCESSOR_ARCHITECTURE=AMD64
rem set UCRTVersion=10.0.19041.0
rem set UniversalCRTSdkDir=%WindowsSdkDir%/
rem set VCIDEInstallDir=%VSINSTALLDIR%/Common7/IDE/VC/
rem set VCINSTALLDIR=%VSINSTALLDIR%/VC/
rem set VCToolsInstallDir=%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/
rem set VCToolsRedistDir=%VSINSTALLDIR%/VC/Redist/MSVC/14.29.30133/
rem set VCToolsVersion=14.29.30133
rem set VisualStudioVersion=16.0
rem set VS160COMNTOOLS=%VSINSTALLDIR%/Common7/Tools/
rem set VSCMD_ARG_app_plat=Desktop
rem set VSCMD_ARG_HOST_ARCH=x64
rem set VSCMD_ARG_TGT_ARCH=x64
rem set VSCMD_VER=16.11.3
rem set WindowsLibPath=%WindowsSdkDir%/UnionMetadata/10.0.19041.0;%WindowsSdkDir%/References/10.0.19041.0
rem set WindowsSdkBinPath=%WindowsSdkDir%/bin/
rem set WindowsSDKLibVersion=10.0.19041.0/
rem set WindowsSdkVerBinPath=%WindowsSdkDir%/bin/10.0.19041.0/
rem set WindowsSDKVersion=10.0.19041.0/

rem additional tools
rem set WINLD=
set MT=
set RC=
rem set WINAR=
rem set DUMPBIN=

rem set path
set PATH=%OJDKBUILD_DIR%/tools/cygwin_jdk11/bin/path_prepend
set PATH=%PATH%;%WindowsSdkDir%/bin/10.0.19041.0/x64;%WindowsSdkDir%/bin/x64;%WindowsSdkDir%/bin/10.0.19041.0/x86
set PATH=%PATH%;%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64

rem set PATH=%PATH%;%VSINSTALLDIR%/VC/Tools/MSVC/14.29.30133/bin/HostX64/x64;%VSINSTALLDIR%/Common7/IDE/VC/VCPackages
rem set PATH=%PATH%;%WindowsSdkDir%/bin/10.0.19041.0/x64;%WindowsSdkDir%/bin/x64;%VSINSTALLDIR%/MSBuild/Current/Bin
rem set PATH=%PATH%;%VSINSTALLDIR%/Common7/IDE/;%VSINSTALLDIR%/Common7/Tools/
rem set PATH=%PATH%;%VSINSTALLDIR%/VC/Redist/MSVC/14.29.30133/x64/Microsoft.VC142.CRT
rem set PATH=%PATH%;%WindowsSdkDir%/Redist/10.0.19041.0/ucrt/x64;%WindowsSdkDir%/Redist/10.0.19041.0/ucrt/x86
rem set PATH=%PATH%;%VSINSTALLDIR%/Common7/Tools/devinit

set PATH=%PATH%;C:/Windows/system32;C:/Windows;C:/Windows/System32/Wbem
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/cmake/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/pkgconfig/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/cygwin_jdk11/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/maven/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/resources/scripts
