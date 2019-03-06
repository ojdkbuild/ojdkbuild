# Copyright 2019, akashche at redhat.com
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

# version
set ( ${PROJECT_NAME}_MAJOR_VERSION "12" CACHE STRING "Major version number" )
set ( ${PROJECT_NAME}_UPDATE "0" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_BUILD "33" CACHE STRING "Version string 'build' field" )
set ( ${PROJECT_NAME}_RPMBUILD "0" CACHE STRING "Build number in image name" )

# options
set ( ${PROJECT_NAME}_DEST_DIR ${OJDKBUILD_DIR}/dist CACHE STRING "Destination directory" )
set ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE OFF CACHE BOOL "Enable bootcycle build" )
set ( ${PROJECT_NAME}_ENABLE_JMC ON CACHE BOOL "Enable JDK Mission Control build" )
# zip bundle options
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "9" CACHE STRING "ZIP compress level" )
# debug options
if ( CMAKE_BUILD_TYPE MATCHES "Release" )
    if ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE )
        set ( ${PROJECT_NAME}_IMAGES_TARGET "bootcycle-images" CACHE INTERNAL "" )
    else ( )
        set ( ${PROJECT_NAME}_IMAGES_TARGET "images" CACHE INTERNAL "" )
    endif ( )
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "release" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_IMAGE_LABEL "" CACHE INTERNAL "" )
elseif ( CMAKE_BUILD_TYPE MATCHES "Debug" )
    set ( ${PROJECT_NAME}_IMAGES_TARGET "images" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "slowdebug" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_IMAGE_LABEL "-debug" CACHE INTERNAL "" )
else ( )
    message ( FATAL_ERROR "Unsupported build type: [${CMAKE_BUILD_TYPE}]" )
endif ( )
# bootcycle vars
if ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE )
    set ( ${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/bootcycle-build/images/jdk" CACHE INTERNAL "" )
else ( )
    set ( ${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/images/jdk" CACHE INTERNAL "" )
endif ( )

# image naming
set ( ${PROJECT_NAME}_EXE_VERSION "${${PROJECT_NAME}_MAJOR_VERSION},${${PROJECT_NAME}_UPDATE},${${PROJECT_NAME}_BUILD},${${PROJECT_NAME}_RPMBUILD}" CACHE INTERNAL "EXE version field" )
set ( ${PROJECT_NAME}_FILE_VERSION "${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}.${${PROJECT_NAME}_BUILD}.${${PROJECT_NAME}_RPMBUILD}" CACHE INTERNAL "File version field" )
set ( ${PROJECT_NAME}_BASE_PREFIX java-${${PROJECT_NAME}_MAJOR_VERSION}-openjdk${${PROJECT_NAME}_DEBUG_IMAGE_LABEL} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE_POSTFIX ${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}.${${PROJECT_NAME}_BUILD}-${${PROJECT_NAME}_RPMBUILD}.windows.${${PROJECT_NAME}_VENDOR_LOWERCASE} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE ${${PROJECT_NAME}_BASE_PREFIX}-${${PROJECT_NAME}_BASE_POSTFIX} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_IMAGE ${${PROJECT_NAME}_BASE}.x86_64 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SRCBUNDLE ${${PROJECT_NAME}_BASE}.src CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEBUGBUNDLE ${${PROJECT_NAME}_IMAGE}.debuginfo CACHE INTERNAL "" )

# copy and other helpers
set ( ${PROJECT_NAME}_RBCFLAGS /ndl /njh /njs /nc /ns /np CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RBCPOSTFIX ^& if errorlevel 1 if not errorlevel 2 exit 0 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_FONTS_SRC ${OJDKBUILD_DIR}/lookaside/dejavu-fonts CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_FONTS_DEST ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/lib/fonts CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_WIXGEN_JVM_OPTS -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Dcom.sun.xml.bind.v2.bytecode.ClassTailor.noOptimize=true CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 CACHE INTERNAL "" )

# dependencies
# JDK Mission Control
if ( ${PROJECT_NAME}_ENABLE_JMC )
    if ( NOT DEFINED jmc_JAVA_HOME )
        set ( jmc_JAVA_HOME ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE} CACHE STRING "Path to jdk to use for building JMC" )
    endif ( )
    add_subdirectory ( ${OJDKBUILD_DIR}/deps/jmc jmc )
endif ( )

# resources
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/env.bat
        ${CMAKE_CURRENT_BINARY_DIR}/env.bat )

# targets

add_custom_target ( builddir
        COMMAND if not exist ${PROJECT_NAME} mkdir ${PROJECT_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing build directory ..." )

add_custom_target ( cygwin
        COMMAND bash -c "rm -f /dev/fd"
        COMMAND bash -c "ln -s /proc/self/fd /dev/fd"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing Cygwin ..." )

add_custom_command ( OUTPUT ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin/java.exe
        COMMAND if not exist spec.gmk
                cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash ${OJDKBUILD_DIR}/upstream/jdk/configure
                --disable-hotspot-gtest
                --disable-warnings-as-errors
                --enable-unlimited-crypto=yes
                --with-boot-jdk=C:/apps/jdk11
                --with-cacerts-file=${OJDKBUILD_DIR}/lookaside/ca-certificates/cacerts
                --with-debug-level=${${PROJECT_NAME}_DEBUG_LEVEL}
                --with-log=info
                --with-native-debug-symbols=external
                --with-version-build=${${PROJECT_NAME}_BUILD}
                --with-version-pre=${${PROJECT_NAME}_VENDOR_LOWERCASE}
                --with-num-cores=4
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash -c "make ${${PROJECT_NAME}_IMAGES_TARGET}"
        # deplibs
        DEPENDS builddir
                cygwin
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Building OpenJDK ..." )
add_custom_target ( ${PROJECT_NAME} DEPENDS ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin/java.exe )

add_custom_target ( preimage
        # copy image
        COMMAND if exist ${${PROJECT_NAME}_IMAGE} rd /s /q ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH} ${${PROJECT_NAME}_IMAGE} /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # remove demo
        #COMMAND cd ${${PROJECT_NAME}_IMAGE} && rd /s /q demo
        # add fonts
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC}/ttf ${${PROJECT_NAME}_FONTS_DEST} /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} LICENSE /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} AUTHORS /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} README /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS ${PROJECT_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating preliminary image ..." )

add_custom_target ( image
        # extract debuginfo
        COMMAND if exist ${${PROJECT_NAME}_DEBUGBUNDLE} rd /s /q ${${PROJECT_NAME}_DEBUGBUNDLE}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${${PROJECT_NAME}_IMAGE}/bin/server
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.pdb /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.map /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.pdb /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.map /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        #COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        #COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS preimage
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image ..." )

add_custom_target ( image_jmc
        COMMAND (robocopy jmc/dist ${${PROJECT_NAME}_IMAGE}/missioncontrol /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS image jmc
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image with JMC ..." )

add_custom_target ( debuginfo
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/tools/zip/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_DEBUGBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_DEBUGBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating debuginfo bundle ..." )
if ( ${PROJECT_NAME}_ENABLE_JMC )
    add_dependencies ( debuginfo image_jmc )
else ( )
    add_dependencies ( debuginfo image )
endif ( )

add_custom_target ( zip
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/tools/zip/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS debuginfo
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP bundle ..." )

add_custom_target ( devshell
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat bash
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Starting development shell session ..." )

