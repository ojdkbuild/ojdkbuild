#!/bin/bash
#
# Copyright 2016, akashche at redhat.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -x

# find out which boot jdk to use
if [ -d "${${PROJECT_NAME}_BOOT_JDK_DIR}/images/j2sdk-image" ]; then
    BOOTJDK=${${PROJECT_NAME}_BOOT_JDK_DIR}/images/j2sdk-image
else 
    BOOTJDK=${CMAKE_CURRENT_LIST_DIR}/../../tools/bootjdk7
fi

bash ${CMAKE_CURRENT_LIST_DIR}/../../lookaside/java-1.8.0-openjdk/configure \
    --enable-unlimited-crypto=${${PROJECT_NAME}_UNLIMITED_CRYPTO_FLAG} \
    --enable-debug-symbols=yes \
    --with-target-bits=${${PROJECT_NAME}_TARGET_BITS} \
    --with-debug-level=${${PROJECT_NAME}_DEBUG_LEVEL} \
    --with-cacerts-file=${CMAKE_CURRENT_LIST_DIR}/../../lookaside/ca-certificates/cacerts \
    --with-boot-jdk=$BOOTJDK \
    --with-tools-dir=${CMAKE_CURRENT_LIST_DIR}/../../tools/toolchain/vs2010e/VC/bin/${${PROJECT_NAME}_VCTOOLS_PATH} \
    --with-msvcr-dll=${CMAKE_CURRENT_LIST_DIR}/../../tools/toolchain/msvcr100/${${PROJECT_NAME}_MSVCR_PATH}/msvcr100${${PROJECT_NAME}_DEBUG_DLL_POSTFIX}.dll \
    --with-freetype-include=${CMAKE_CURRENT_LIST_DIR}/../../lookaside/freetype/include/ \
    --with-freetype-lib=${CMAKE_CURRENT_BINARY_DIR}/bin \
    --with-num-cores=1 \
    --with-milestone=${${PROJECT_NAME}_RPMBUILD}-${${PROJECT_NAME}_MILESTONE} \
    --with-update-version=${${PROJECT_NAME}_UPDATE} \
    --with-build-number=b${${PROJECT_NAME}_BUILD} \
    OJDKBUILD_LIBC_STATIC_FLAG=-MT${${PROJECT_NAME}_DEBUG_DLL_POSTFIX} \
    OJDKBUILD_LIBC_DYNAMIC_FLAG=-MD${${PROJECT_NAME}_DEBUG_DLL_POSTFIX} \
    2>&1

if [ "OFF" == "${${PROJECT_NAME}_DEV_MODE}" ]; then
    make images \
        JAVAC_FLAGS=-g \
        LOG=${${PROJECT_NAME}_LOG_LEVEL} \
        2>&1
    exit $?
fi
