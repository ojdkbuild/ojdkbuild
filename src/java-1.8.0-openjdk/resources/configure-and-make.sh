#!/bin/bash

set -x

bash ./configure \
    --enable-unlimited-crypto \
    --disable-debug-symbols \
    --disable-precompiled-headers \
    --disable-ccache \
    --with-debug-level=release \
    --with-cacerts-file=${CMAKE_CURRENT_LIST_DIR}/../../resources/cacerts/cacerts \
    --with-boot-jdk=${CMAKE_CURRENT_LIST_DIR}/../../tools/bootjdk \
    --with-tools-dir=${CMAKE_CURRENT_LIST_DIR}/../../tools/toolchain/sdk71/vs2010e/VC/bin/x86_amd64 \
    --with-msvcr-dll=${CMAKE_CURRENT_LIST_DIR}/../../tools/toolchain/msvcr/amd64/msvcr100.dll \
    --with-freetype-include=${CMAKE_CURRENT_LIST_DIR}/../../src/freetype/lookaside_freetype/include/ \
    --with-freetype-lib=${CMAKE_CURRENT_BINARY_DIR}/freetype \
    --with-num-cores=1 \
    --with-milestone=${${PROJECT_NAME}_MILESTONE} \
    --with-update-version=${${PROJECT_NAME}_UPDATE} \
    --with-build-number=b${${PROJECT_NAME}_BUILD} \
    2>&1

make images LOG=trace 2>&1

exit $?
