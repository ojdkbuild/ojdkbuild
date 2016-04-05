@echo on

rem set path
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/make
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/cygwin/bin
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/bootjdk7/bin
rem prepend
set PATH=${CMAKE_CURRENT_LIST_DIR}/../../tools/cygwin/bin/path_prepend;%PATH%

rem pkg-config
set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%;${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig

rem other variables
set CYGWIN=nodosfilewarning

rem start build
pushd "${CMAKE_CURRENT_LIST_DIR}/../../lookaside/java-1.8.0-openjdk" || exit /b 1
rmdir /s /q build
if exist build exit /b 1

bash "${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.sh"
if 0 neq %ERRORLEVEL% exit /b 1

if "ON" == "${${PROJECT_NAME}_DEV_MODE}" (
    bash
)

popd || exit /b 1
