@echo on

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set OJDKBUILD_DIR=%SCRIPT_DIR%/../..

rem tools dirs
set VS=%OJDKBUILD_DIR%/tools/toolchain/vs2010e
set WINSDK=%OJDKBUILD_DIR%/tools/toolchain/sdk71

rem set compiler environment manually
set WINDOWSSDKDIR=%WINSDK%
set VS100COMNTOOLS=%VS%/Common7/Tools
set Configuration=Release
set WindowsSDKVersionOverride=v7.1
set ToolsVersion=4.0
set TARGET_CPU=x64
set CURRENT_CPU=x64
set PlatformToolset=Windows7.1SDK
set TARGET_PLATFORM=XP
set LIB=%VS%/VC/Lib/amd64;%WINSDK%/Lib/x64
set LIBPATH=%VS%/VC/Lib/amd64
set INCLUDE=%VS%/VC/INCLUDE;%WINSDK%/INCLUDE;%WINSDK%/INCLUDE/gl;

rem additional tools
set WINLD=%VS%/VC/Bin/x86_amd64/link.exe
set MT=%WINSDK%/Bin/mt.exe
set RC=%WINSDK%/Bin/rc.exe
set WINAR=%VS%/VC/Bin/x86_amd64/lib.exe
set DUMPBIN=%VS%/VC/Bin/x86_amd64/dumpbin.exe

rem set path
set PATH=%VS%/Common7/IDE;%VS%/Common7/Tools;%VS%/VC/Bin/x86_amd64;%VS%/VC/Bin;%VS%/VC/Bin/VCPackages
set PATH=%PATH%;%WINSDK%/Bin;C:/WINDOWS/System32;C:/WINDOWS;C:/WINDOWS/System32/wbem
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/toolchain/msvcr100/amd64;%OJDKBUILD_DIR%/tools/toolchain/msvcr100/i586
set PATH=%PATH%;%VS%/Common7/IDE
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/cmake/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/tools/pkgconfig/bin
set PATH=%PATH%;%OJDKBUILD_DIR%/resources/scripts
