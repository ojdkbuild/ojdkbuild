@echo on

rem set path
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/make
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/cygwin/bin
set PATH=%PATH%;${CMAKE_CURRENT_LIST_DIR}/../../tools/bootjdk/bin
rem prepend
set PATH=${CMAKE_CURRENT_LIST_DIR}/../../tools/cygwin/bin/path_prepend;%PATH%

rem other variables
set CYGWIN=nodosfilewarning

rem start build
pushd "${CMAKE_CURRENT_LIST_DIR}/lookaside_java-1.8.0-openjdk" || exit /b 1
rmdir /s /q build
if exist build exit /b 1
bash "${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.sh"
if 0 neq %ERRORLEVEL% exit /b 1
popd || exit /b 1
