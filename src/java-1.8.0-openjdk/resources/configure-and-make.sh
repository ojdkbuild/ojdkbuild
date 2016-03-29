#!/bin/bash

set -x

bash ./configure \
    --enable-unlimited-crypto \
    --disable-debug-symbols \
    --disable-precompiled-headers \
    --disable-ccache \
    --with-debug-level=release \
    --with-cacerts-file=${CMAKE_CURRENT_LIST_DIR}/../../resources/cacerts/cacerts \
    --with-boot-jdk=${CMAKE_CURRENT_LIST_DIR}/../../tools/bootjdk7 \
    --with-tools-dir=${CMAKE_CURRENT_LIST_DIR}/../../tools/toolchain/vs2010e/VC/bin/x86_amd64 \
    --with-msvcr-dll=${CMAKE_CURRENT_LIST_DIR}/../../tools/toolchain/msvcr100/amd64/msvcr100.dll \
    --with-freetype-include=${CMAKE_CURRENT_LIST_DIR}/../../lookaside/freetype/include/ \
    --with-freetype-lib=${CMAKE_CURRENT_BINARY_DIR}/bin \
    --with-num-cores=1 \
    --with-milestone=${${PROJECT_NAME}_MILESTONE} \
    --with-update-version=${${PROJECT_NAME}_UPDATE} \
    --with-build-number=b${${PROJECT_NAME}_BUILD} \
    2>&1

make images LOG=trace 2>&1

exit $?
