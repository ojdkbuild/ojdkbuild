#!/bin/bash
#
# Copyright 2017, akashche at redhat.com
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

# http://www.ducea.com/2009/02/18/linux-tips-bash-completion-devfd62-no-such-file-or-directory/
rm -f /dev/fd
ln -s /proc/self/fd /dev/fd

bash ${CMAKE_CURRENT_LIST_DIR}/../../lookaside/java-9-openjdk/configure \
    --enable-unlimited-crypto \
    --with-devkit=${CMAKE_CURRENT_LIST_DIR}/../../tools/toolchain/vs2013e/ \
    --with-cacerts-file=${CMAKE_CURRENT_LIST_DIR}/../../lookaside/ca-certificates/cacerts \
    --with-boot-jdk=${CMAKE_CURRENT_LIST_DIR}/../../tools/bootjdk8 \
    --with-freetype=${CMAKE_CURRENT_LIST_DIR}/../../deps/freetype-bin \
    --with-version-pre=${${PROJECT_NAME}_MILESTONE} \
    --with-version-major=${${PROJECT_NAME}_MAJOR_VERSION} \
    --with-version-minor=${${PROJECT_NAME}_UPDATE} \
    --with-version-security=0 \
    --with-version-patch=${${PROJECT_NAME}_RPMBUILD} \
    --with-version-build=${${PROJECT_NAME}_BUILD} \
    --with-version-opt=${${PROJECT_NAME}_MONOTONIC_VERSION_NUMBER}.builder.experimental \
    --with-num-cores=1 \
    2>&1

if [ "OFF" == "${${PROJECT_NAME}_DEV_MODE}" ]; then
    make images \
        LOG=${${PROJECT_NAME}_LOG_LEVEL} \
        2>&1
    exit $?
fi

