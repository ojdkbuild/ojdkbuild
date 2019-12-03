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

cmake_minimum_required ( VERSION 2.8.12 )

# project
set ( OJDKBUILD_DIR ${CMAKE_CURRENT_LIST_DIR}/../.. CACHE INTERNAL "" )
include ( ${OJDKBUILD_DIR}/resources/cmake/ojdkbuild_common.cmake )
project ( openjdk NONE )
include ( ${OJDKBUILD_DIR}/resources/cmake/version.cmake )

# version
set ( ${PROJECT_NAME}_MILESTONE "ojdkbuild" CACHE STRING "Version string 'milestone' field" )
set ( ${PROJECT_NAME}_MAJOR_VERSION "8" CACHE STRING "Major version number" )
set ( ${PROJECT_NAME}_UPDATE "232" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_BUILD "09" CACHE STRING "Version string 'build' field" )
set ( ${PROJECT_NAME}_RPMBUILD "0" CACHE STRING "Build number in image name" )

# options
set ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE OFF CACHE BOOL "Build bootstrap jdk first and then build the final one using it as bootjdk" )
set ( ${PROJECT_NAME}_ENABLE_32_BIT OFF CACHE BOOL "Build 32-bit binaries" )
set ( ${PROJECT_NAME}_ENABLE_OPENJFX OFF CACHE BOOL "Enable building OpenJFX" )
set ( ${PROJECT_NAME}_ENABLE_CLEANUP OFF CACHE BOOL "Delete temporary build files before creating the installer" )
set ( ${PROJECT_NAME}_DEST_DIR ${OJDKBUILD_DIR}/dist CACHE STRING "Destination directory" )
set ( ${PROJECT_NAME}_LOG_LEVEL "info" CACHE STRING "Logging verbosity during the build" )
# zip bundle options
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "9" CACHE STRING "ZIP compress level" )
# installer options
set ( ${PROJECT_NAME}_INSTALLER_JDK_RELEASE "${${PROJECT_NAME}_MAJOR_VERSION}" CACHE STRING "JDK major version for installer" )
set ( ${PROJECT_NAME}_INSTALLER_VENDOR ${${PROJECT_NAME}_VENDOR} CACHE STRING "Installer vendor label" )
set ( ${PROJECT_NAME}_INSTALLER_VENDOR_DIRNAME ${${PROJECT_NAME}_VENDOR_DIRNAME} CACHE STRING "Installer vendor directory" )
set ( ${PROJECT_NAME}_INSTALLER_HELP_LINK "https://github.com/ojdkbuild" CACHE STRING "Installer help link" )
if ( ${PROJECT_NAME}_ENABLE_32_BIT )
    set ( ${PROJECT_NAME}_INSTALLER_PRODUCT_UUID "c9a2aecd-1975-4669-b39a-ff22e7c3ba16" CACHE STRING "Installer product UUID" )
    set ( ${PROJECT_NAME}_INSTALLER_UPDATE_UUID "29446195-44d4-43a9-b3cb-5784c4a87d82" CACHE STRING "Installer update UUID" )
else ( )
    set ( ${PROJECT_NAME}_INSTALLER_PRODUCT_UUID "f95c3f29-dcd8-4484-a01f-4de9c78d71bc" CACHE STRING "Installer product UUID" )
    set ( ${PROJECT_NAME}_INSTALLER_UPDATE_UUID "e1f56661-f988-4f2f-959a-678ac35e6176" CACHE STRING "Installer update UUID" )
endif ( )
set ( ${PROJECT_NAME}_INSTALLER_RESOURCES_PATH "${OJDKBUILD_DIR}/resources/installer/instres" CACHE STRING "Path to installer resources" )
set ( ${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS "" CACHE STRING "Additional options to pass to installer's linker" )
set ( ${PROJECT_NAME}_INSTALLER_JDK_FEATURE_DESCRIPTION "OpenJDK 8 runtime files." CACHE STRING "Description label of the OpenJDK feature in installer" )
set ( ${PROJECT_NAME}_INSTALLER_JRE_DIR "jre\\\\" CACHE STRING "JRE dir to use for registry keys" )
set ( ${PROJECT_NAME}_INSTALLER_USE_FEATURE_TREE true CACHE STRING "Whether to use installer feature tree" )
set ( ${PROJECT_NAME}_INSTALLER_FEATURE_LEVEL "1" CACHE STRING "MSI Feature 'Level' for 'jdk' sub-components" )

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

# arch vars
if ( ${PROJECT_NAME}_ENABLE_32_BIT )
    set ( ${PROJECT_NAME}_ARCH "x86" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_TARGET_BITS "32" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_BOOT_JDK "${OJDKBUILD_DIR}/tools/bootjdk7_32" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_MSVCR_PATH "i586" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_INSTALLER_WIN64 "false" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_INSTALLER_WIN64_WIX "no" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_INSTALLER_WIN64_EXEC_WIX "" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_INSTALLER_ARCH_LABEL "-x86" CACHE INTERNAL "" )
else ( )
    set ( ${PROJECT_NAME}_ARCH "x86_64" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_TARGET_BITS "64" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_BOOT_JDK "${OJDKBUILD_DIR}/tools/bootjdk7" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_MSVCR_PATH "amd64" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_INSTALLER_WIN64 "true" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_INSTALLER_WIN64_WIX "yes" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_INSTALLER_WIN64_EXEC_WIX "64" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_INSTALLER_ARCH_LABEL "" CACHE INTERNAL "" )
endif ( )

# bootcycle vars
if ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE )
    set ( ${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/bootcycle-build/images/j2sdk-image" CACHE INTERNAL "" )
else ( )
    set ( ${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/images/j2sdk-image" CACHE INTERNAL "" )
endif ( )

# image naming
# 1<major><major><update><update><update><build><build><build><release><release>
set ( ${PROJECT_NAME}_MONOTONIC_VERSION_NUMBER 10${${PROJECT_NAME}_MAJOR_VERSION}${${PROJECT_NAME}_UPDATE}0${${PROJECT_NAME}_RPMBUILD}0${${PROJECT_NAME}_BUILD} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_EXE_VERSION "1,${openjdk_MAJOR_VERSION},${openjdk_UPDATE}${openjdk_RPMBUILD},${openjdk_BUILD}" CACHE INTERNAL "EXE version field" )
set ( ${PROJECT_NAME}_FILE_VERSION "1.${openjdk_MAJOR_VERSION}.0.${openjdk_UPDATE}.${openjdk_RPMBUILD}" CACHE INTERNAL "File version field" )
set ( ${PROJECT_NAME}_BASE_PREFIX java-1.${${PROJECT_NAME}_MAJOR_VERSION}.0-openjdk${${PROJECT_NAME}_DEBUG_IMAGE_LABEL} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE_POSTFIX 1.${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}-${${PROJECT_NAME}_RPMBUILD}.b${${PROJECT_NAME}_BUILD}.${${PROJECT_NAME}_MILESTONE}.windows CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE ${${PROJECT_NAME}_BASE_PREFIX}-${${PROJECT_NAME}_BASE_POSTFIX} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_JRE_BASE java-1.${${PROJECT_NAME}_MAJOR_VERSION}.0-openjdk-jre-${${PROJECT_NAME}_BASE_POSTFIX} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_IMAGE ${${PROJECT_NAME}_BASE}.${${PROJECT_NAME}_ARCH} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_JRE_IMAGE ${${PROJECT_NAME}_JRE_BASE}.${${PROJECT_NAME}_ARCH} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SRCBUNDLE ${${PROJECT_NAME}_BASE}.src CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_TESTBUNDLE ${${PROJECT_NAME}_BASE}.test CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEBUGBUNDLE ${${PROJECT_NAME}_IMAGE}.debuginfo CACHE INTERNAL "" )

# copy and other helpers
set ( ${PROJECT_NAME}_RBCFLAGS /ndl /njh /njs /nc /ns /np CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RBCPOSTFIX ^& if errorlevel 1 if not errorlevel 2 exit 0 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_TOOLS ${CMAKE_CURRENT_LIST_DIR}/../../tools CACHE INTERNAL "" )

# dependencies
if ( ${PROJECT_NAME}_ENABLE_32_BIT )
    set ( STATICLIB_TOOLCHAIN windows_i386_msvc CACHE INTERNAL "" )
else ( )
    set ( STATICLIB_TOOLCHAIN windows_amd64_msvc CACHE INTERNAL "" )
endif ( )
# freetype
set ( freetype_MSVC_ALT_CRUNTIME "/MD" CACHE INTERNAL "" )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/freetype ojdkbuild_freetype )
# zlib
set ( z_MSVC_ALT_CRUNTIME "/MD" CACHE INTERNAL "" )
ojdkbuild_add_external ( ${OJDKBUILD_DIR}/external/zlib )
add_dependencies ( external_zlib z_altcr )
# giflib
set ( gif_MSVC_ALT_CRUNTIME "/MD" CACHE INTERNAL "" )
ojdkbuild_add_external ( ${OJDKBUILD_DIR}/external/giflib )
# libjpeg-turbo
set ( libjpeg-turbo_MSVC_ALT_CRUNTIME "/MD" CACHE INTERNAL "" )
ojdkbuild_add_external ( ${OJDKBUILD_DIR}/external/libjpeg-turbo )
# libpng
set ( png_MSVC_ALT_CRUNTIME "/MD" CACHE INTERNAL "" )
ojdkbuild_add_external ( ${OJDKBUILD_DIR}/external/libpng )

# update notifier
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/contrib/update-notifier update_notifier )
# icedtea-web
if ( NOT DEFINED icedtea_web_ITW_JAVA_HOME )
    set ( icedtea_web_ITW_JAVA_HOME ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE} CACHE STRING "Path to jdk to use for building IcedTea-Web" )
endif ( )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/icedtea-web icedtea_web )
# openjfx
if ( ${PROJECT_NAME}_ENABLE_OPENJFX ) 
    if ( NOT DEFINED openjfx_OJFX_JAVA_HOME )
        set ( openjfx_OJFX_JAVA_HOME ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE} CACHE STRING "Path to jdk to use for building OpenJFX" )
    endif ( )
    ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/openjfx openjfx )
endif ( )

# resources
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/env.bat
        ${CMAKE_CURRENT_BINARY_DIR}/env.bat )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/installer.json
        ${CMAKE_CURRENT_BINARY_DIR}/installer.json )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/jdk_devel.xsl
        ${CMAKE_CURRENT_BINARY_DIR}/jdk_devel.xsl )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/jdk_registry_env.xsl
        ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl )

# shorcut vars
set ( ${PROJECT_NAME}_FONTS_SRC ${CMAKE_CURRENT_LIST_DIR}/../../lookaside/dejavu-fonts CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_FONTS_DEST ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/jre/lib/fonts CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_WIXGEN_JVM_OPTS -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 CACHE INTERNAL "" )

# targets

add_custom_target ( builddir
        COMMAND if not exist ${PROJECT_NAME} mkdir ${PROJECT_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing build directory ..." )

add_custom_target ( tzdata
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/make/data/tzdata
                africa antarctica asia australasia backward etcetera europe factory iso3166.tab leapseconds northamerica
                pacificnew southamerica systemv zone.tab ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/make/data/tzdata
                VERSION ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Copying timezone data ..." )

add_custom_target ( icons
        COMMAND if exist icons rmdir /s /q icons
        COMMAND mkdir icons
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} icons icon.ico ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd icons && rename icon.ico awt.ico
        COMMAND (robocopy icons ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/src/windows/resource/icons
                ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} icons icon.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd icons && rename icon.png netx-icon.png
        COMMAND (robocopy icons ${OJDKBUILD_DIR}/lookaside/icedtea-web/netx/net/sourceforge/jnlp/resources
                netx-icon.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/src/share/classes/com/sun/java/swing/plaf/windows/icons
                JavaCup32.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/src/share/classes/javax/swing/plaf/basic/icons
                JavaCup16.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Copying icons ..." )

add_custom_command ( OUTPUT ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin/java.exe
        COMMAND if not exist spec.gmk
                cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/configure
                --enable-unlimited-crypto=yes
                --enable-debug-symbols=yes
                --with-target-bits=${${PROJECT_NAME}_TARGET_BITS}
                --with-debug-level=${${PROJECT_NAME}_DEBUG_LEVEL}
                --with-cacerts-file=${OJDKBUILD_DIR}/lookaside/ca-certificates/cacerts
                --with-boot-jdk=${${PROJECT_NAME}_BOOT_JDK}
                --with-msvcr-dll=${OJDKBUILD_DIR}/tools/toolchain/msvcr100/${${PROJECT_NAME}_MSVCR_PATH}/msvcr100.dll
                --with-freetype-include=${OJDKBUILD_DIR}/lookaside/freetype/include/
                --with-freetype-lib=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/
                --with-num-cores=1
                --with-milestone=fcs
                --with-update-version=${${PROJECT_NAME}_UPDATE}
                --with-build-number=b${${PROJECT_NAME}_BUILD}
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash -c "make ${${PROJECT_NAME}_IMAGES_TARGET} LOG=${${PROJECT_NAME}_LOG_LEVEL} JAVAC_FLAGS=-g"
        DEPENDS builddir
                ojdkbuild_freetype
                external_zlib
                external_giflib
                external_libjpeg-turbo
                external_libpng
                icons
                tzdata
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Building OpenJDK ..." )
add_custom_target ( ${PROJECT_NAME} DEPENDS ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin/java.exe )

add_custom_target ( preimage
        # copy image
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH} ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}
                /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # remove demo and sample
        COMMAND cd ${${PROJECT_NAME}_IMAGE} && rd /s /q demo
        COMMAND cd ${${PROJECT_NAME}_IMAGE} && rd /s /q sample
        # add fonts
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC}/ttf ${${PROJECT_NAME}_FONTS_DEST} /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} LICENSE /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} AUTHORS /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} README /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS ${PROJECT_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating preliminary image ..." )

add_custom_target ( preimage_cleanup
        COMMAND rd /s /q ${PROJECT_NAME}
        DEPENDS preimage
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Deleting temporary build artifacts ..." )

add_custom_target ( image
        # extract debuginfo
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_DEBUGBUNDLE}
        COMMAND ${CMAKE_COMMAND} -E remove_directory diz
        COMMAND ${CMAKE_COMMAND} -E make_directory ${${PROJECT_NAME}_IMAGE}/jre/bin/server
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND pushd ${${PROJECT_NAME}_DEBUGBUNDLE} && ${${PROJECT_NAME}_TOOLS}/zip/unzip.exe -q *.diz
        COMMAND (robocopy ${${PROJECT_NAME}_DEBUGBUNDLE}/ diz/ *.diz /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # jre
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre ${${PROJECT_NAME}_JRE_IMAGE} /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image ..." )

if ( ${PROJECT_NAME}_ENABLE_CLEANUP )
    add_dependencies ( image preimage_cleanup )
else ( )
    add_dependencies ( image preimage )
endif ( )

add_custom_target ( image_debug
        # unzip debuginfo
        COMMAND ${CMAKE_COMMAND} -E remove_directory diz
        COMMAND pushd ${${PROJECT_NAME}_IMAGE}\\jre\\bin && ${${PROJECT_NAME}_TOOLS}/zip/unzip.exe -q *.diz
        COMMAND pushd ${${PROJECT_NAME}_IMAGE}\\jre\\bin\\server && ${${PROJECT_NAME}_TOOLS}/zip/unzip.exe -q *.diz
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_IMAGE}/jre/bin *.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_IMAGE}/jre/bin *.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}/src.zip
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating debug image ..." )

if ( ${PROJECT_NAME}_ENABLE_CLEANUP )
    add_dependencies ( image_debug preimage_cleanup )
else ( )
    add_dependencies ( image_debug preimage )
endif ( )

add_custom_target ( debuginfo
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_DEBUGBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_DEBUGBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/sha256file.js ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_DEBUGBUNDLE}.zip
        DEPENDS image
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating debuginfo bundle ..." )

add_custom_target ( image_itw
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/icedtea_web/dist ${${PROJECT_NAME}_IMAGE}/webstart /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS debuginfo icedtea_web
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Adding IcedTea-Web to image ..." )

add_custom_target ( zip
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/sha256file.js ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.zip
        # jre
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_JRE_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_JRE_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/sha256file.js ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_JRE_IMAGE}.zip
        DEPENDS image_itw
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP bundle ..." )

add_custom_target ( zip_debug
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/sha256file.js ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.zip
        DEPENDS image_debug
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP debug bundle ..." )

add_custom_target ( installer_bundle_contents
        COMMAND if exist ${${PROJECT_NAME}_IMAGE}.installer_bundle rd /s /q ${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE} ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && mkdir devel
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk/bin ${${PROJECT_NAME}_IMAGE}.installer_bundle/devel/bin /mov /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q bin
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk/include ${${PROJECT_NAME}_IMAGE}.installer_bundle/devel/include /mov /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q include
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk/lib ${${PROJECT_NAME}_IMAGE}.installer_bundle/devel/lib /mov /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q lib
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk ${${PROJECT_NAME}_IMAGE}.installer_bundle/devel src.zip /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q webstart
        COMMAND (robocopy openjfx/${openjfx_IMAGE} ${${PROJECT_NAME}_IMAGE}.installer_bundle/openjfx /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy icedtea_web/dist ${${PROJECT_NAME}_IMAGE}.installer_bundle/webstart /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy update_notifier/dist ${${PROJECT_NAME}_IMAGE}.installer_bundle/update /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_IMAGE}.installer_bundle/resources /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS zip openjfx_zip icedtea_web update_notifier_dist
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing MSI installer bundle ..." )

add_custom_target ( installer_bundle_contents_webstart
        COMMAND if exist ${${PROJECT_NAME}_IMAGE}.installer_bundle rd /s /q ${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE} ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && mkdir devel
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk/bin ${${PROJECT_NAME}_IMAGE}.installer_bundle/devel/bin /mov /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q bin
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk/include ${${PROJECT_NAME}_IMAGE}.installer_bundle/devel/include /mov /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q include
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk/lib ${${PROJECT_NAME}_IMAGE}.installer_bundle/devel/lib /mov /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q lib
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk ${${PROJECT_NAME}_IMAGE}.installer_bundle/devel src.zip /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q webstart
        COMMAND (robocopy icedtea_web/dist ${${PROJECT_NAME}_IMAGE}.installer_bundle/webstart /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_IMAGE}.installer_bundle/resources /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS zip icedtea_web
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing MSI WebStart installer bundle ..." )

add_custom_target ( installer_bundle
        # jdk_base
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer.json
                -o jdk_base.wxs
        # devel
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_base.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_devel.xsl
                -o jdk_devel.wxs
        # jdk
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_devel.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl
                -o ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
        # openjfx
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/openjfx/installer.xsl
                -o ${${PROJECT_NAME}_BASE_PREFIX}-openjfx-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
        # webstart
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/icedtea_web/installer.xsl
                -o ${${PROJECT_NAME}_BASE_PREFIX}-webstart-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
        # jdk_openjfx_webstart
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-webstart-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/openjfx/installer.xsl
                -o jdk_openjfx_webstart.wxs
        # jdk_openjfx_webstart_update
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/update_notifier/installer.xsl
                -o jdk_update.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_update.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/icedtea_web/installer.xsl
                -o jdk_webstart_update.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_webstart_update.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/openjfx/installer.xsl
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND cd ${CMAKE_CURRENT_BINARY_DIR} &&
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.installer_bundle.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/sha256file.js ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle.zip
        DEPENDS installer_bundle_contents
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMENT "Creating MSI installer bundle ..." )

add_custom_target ( installer_bundle_webstart
        # jdk_base
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer.json
                -o jdk_base.wxs
        # devel
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_base.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_devel.xsl
                -o jdk_devel.wxs
        # jdk
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_devel.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl
                -o ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
        # webstart
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/icedtea_web/installer.xsl
                -o ${${PROJECT_NAME}_BASE_PREFIX}-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
        COMMAND cd ${CMAKE_CURRENT_BINARY_DIR} &&
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.installer_bundle.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/sha256file.js ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle.zip
        DEPENDS installer_bundle_contents_webstart
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMENT "Creating MSI WebStart installer bundle ..." )

add_custom_target ( installer_bundle_without_notifier
        # jdk_base
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer.json
                -o jdk_base.wxs
        # devel
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_base.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_devel.xsl
                -o jdk_devel.wxs
        # jdk
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_devel.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl
                -o ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
        # openjfx
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/openjfx/installer.xsl
                -o ${${PROJECT_NAME}_BASE_PREFIX}-openjfx-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
        # webstart
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/icedtea_web/installer.xsl
                -o ${${PROJECT_NAME}_BASE_PREFIX}-webstart-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
        # jdk_openjfx_webstart
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-webstart-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/openjfx/installer.xsl
                -o jdk_openjfx_webstart.wxs
        # jdk_openjfx_webstart
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_BASE_PREFIX}-jdk-${${PROJECT_NAME}_BASE_POSTFIX}.${${PROJECT_NAME}_ARCH}.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/icedtea_web/installer.xsl
                -o jdk_webstart.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                jdk_webstart.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/openjfx/installer.xsl
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND cd ${CMAKE_CURRENT_BINARY_DIR} &&
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/zip.js ${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.installer_bundle.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/sha256file.js ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle.zip
        DEPENDS installer_bundle_contents
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMENT "Creating MSI installer bundle without notifier ..." )

add_custom_target ( installer
        COMMAND if exist i rd /s /q i
        COMMAND rename ${${PROJECT_NAME}_IMAGE}.installer_bundle i
        COMMAND cd i && ${${PROJECT_NAME}_TOOLS}/wix/bin/candle -v -nologo ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND cd i && ${${PROJECT_NAME}_TOOLS}/wix/bin/light
                -nologo -sw1076 -ext WixUIExtension -ext WixUtilExtension
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_IMAGE}.wixobj
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/i ${${PROJECT_NAME}_DEST_DIR}
                ${${PROJECT_NAME}_IMAGE}.msi /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/jrunscript.exe ${${PROJECT_NAME}_JRUNSCRIPT_JVM_OPTS}
                ${OJDKBUILD_DIR}/resources/js/sha256file.js ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.msi
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating MSI installer ..." )

if ( ${PROJECT_NAME}_ENABLE_32_BIT )
    add_dependencies ( installer installer_bundle_without_notifier )
elseif ( ${PROJECT_NAME}_ENABLE_OPENJFX )
    add_dependencies ( installer installer_bundle )
else ( )
    add_dependencies ( installer installer_bundle_webstart )
endif ( )

add_custom_target ( srcbundle
        COMMAND (robocopy ${OJDKBUILD_DIR}/contrib/itw-launcher ${${PROJECT_NAME}_SRCBUNDLE}/contrib/itw-launcher /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/contrib/ojdkbuild-utils ${${PROJECT_NAME}_SRCBUNDLE}/contrib/ojdkbuild-utils /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/contrib/update-notifier ${${PROJECT_NAME}_SRCBUNDLE}/contrib/update-notifier /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/freetype ${${PROJECT_NAME}_SRCBUNDLE}/deps/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/icedtea-web ${${PROJECT_NAME}_SRCBUNDLE}/deps/icedtea-web /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/mslinks ${${PROJECT_NAME}_SRCBUNDLE}/deps/mslinks /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/deps/openjfx ${${PROJECT_NAME}_SRCBUNDLE}/deps/openjfx /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/rhino ${${PROJECT_NAME}_SRCBUNDLE}/deps/rhino /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/tagsoup ${${PROJECT_NAME}_SRCBUNDLE}/deps/tagsoup /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/external/curl ${${PROJECT_NAME}_SRCBUNDLE}/external/curl /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/freetype ${${PROJECT_NAME}_SRCBUNDLE}/external/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/giflib ${${PROJECT_NAME}_SRCBUNDLE}/external/giflib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/external/jansson ${${PROJECT_NAME}_SRCBUNDLE}/external/jansson /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/external/libjpeg-turbo /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/libpng ${${PROJECT_NAME}_SRCBUNDLE}/external/libpng /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/external/openssl ${${PROJECT_NAME}_SRCBUNDLE}/external/openssl /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/popt ${${PROJECT_NAME}_SRCBUNDLE}/external/popt /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/zlib ${${PROJECT_NAME}_SRCBUNDLE}/external/zlib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/ca-certificates ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/ca-certificates /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/curl ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/curl /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/dejavu-fonts ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/dejavu-fonts /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/freetype ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/giflib ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/giflib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/icedtea-web ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/icedtea-web /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/jansson ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/jansson /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/java-1.8.0-openjdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/libjpeg-turbo /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/libpng ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/libpng /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/openssl ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/openssl /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/popt ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/popt /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/rhino ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/rhino /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tagsoup ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/tagsoup /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/tzdata /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/zlib ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/zlib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/upstream/mslinks ${${PROJECT_NAME}_SRCBUNDLE}/upstream/mslinks /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND (robocopy ${OJDKBUILD_DIR}/upstream/openjfx-8u ${${PROJECT_NAME}_SRCBUNDLE}/upstream/openjfx-8u /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/buildres ${${PROJECT_NAME}_SRCBUNDLE}/resources/buildres /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/cmake ${${PROJECT_NAME}_SRCBUNDLE}/resources/cmake /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/installer ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/ installer.json ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/resources/tzdata /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/instres /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/src/java-1.8.0-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/src/java-1.8.0-openjdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR} ${${PROJECT_NAME}_SRCBUNDLE} LICENSE ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr0 ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_SRCBUNDLE}.zip ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip
        # COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_SRCBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating sources bundle ..." )

add_custom_target ( devshell
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat bash
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Starting development shell session ..." )
