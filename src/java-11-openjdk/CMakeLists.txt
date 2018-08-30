# Copyright 2018, akashche at redhat.com
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

cmake_minimum_required ( VERSION 2.8.12 )

# project
set ( OJDKBUILD_DIR ${CMAKE_CURRENT_LIST_DIR}/../.. CACHE INTERNAL "" )
include ( ${OJDKBUILD_DIR}/resources/cmake/ojdkbuild_common.cmake )
project ( openjdk NONE )
include ( ${OJDKBUILD_DIR}/resources/cmake/version.cmake )
include ( ${OJDKBUILD_DIR}/resources/cmake/version_11.cmake )

# targets

add_custom_command ( OUTPUT modules
        COMMAND if not exist modules openjdk ${OJDKBUILD_DIR}/tools/zip/unzip -qo modules.zip
        WORKING_DIRECTORY ${OJDKBUILD_DIR}/tools/bootjdk10/lib )

add_custom_target ( bootjdk DEPENDS modules )

add_custom_target ( builddir
        COMMAND if not exist openjdk mkdir openjdk
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )
    
add_custom_target ( cygwin
        COMMAND bash -c "rm -f /dev/fd"
        COMMAND bash -c "ln -s /proc/self/fd /dev/fd"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )

add_custom_target ( ${PROJECT_NAME}
        COMMAND if not exist spec.gmk bash ${OJDKBUILD_DIR}/lookaside/java-11-openjdk/configure
                --disable-hotspot-gtest
                --disable-warnings-as-errors
                --with-boot-jdk=${OJDKBUILD_DIR}/tools/bootjdk10
                --with-num-cores=1
        COMMAND bash -c "make images LOG=info"
        DEPENDS bootjdk builddir cygwin
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/openjdk )
