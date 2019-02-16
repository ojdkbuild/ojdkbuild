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

# options
set ( ${PROJECT_NAME}_DEST_DIR ${OJDKBUILD_DIR}/dist CACHE STRING "Destination directory" )
set ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE OFF CACHE BOOL "Enable bootcycle build" )
set ( ${PROJECT_NAME}_ENABLE_JMC ON CACHE BOOL "Enable JDK Mission Control build" )
set ( ${PROJECT_NAME}_ENABLE_JMC_INSTALLER OFF CACHE BOOL "Include JDK Mission Control into MSI installer" )
# zip bundle options
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "9" CACHE STRING "ZIP compress level" )
# installer options
set ( ${PROJECT_NAME}_INSTALLER_HELP_LINK "https://github.com/ojdkbuild" CACHE STRING "Installer help link" )
set ( ${PROJECT_NAME}_INSTALLER_PRODUCT_UUID "dac3db43-829b-428c-ba4a-3f11a45540d5" CACHE STRING "Installer product UUID" )
set ( ${PROJECT_NAME}_INSTALLER_UPDATE_UUID "a212606f-208b-4dfc-8381-430ada6e2505" CACHE STRING "Installer update UUID" )
set ( ${PROJECT_NAME}_INSTALLER_RESOURCES_PATH "${OJDKBUILD_DIR}/resources/installer/instres" CACHE STRING "Path to installer resources" )
set ( ${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS "" CACHE STRING "Additional options to pass to installer's linker" )
set ( ${PROJECT_NAME}_INSTALLER_JDK_FEATURE_DESCRIPTION "OpenJDK 11 runtime files." CACHE STRING "Description label of the OpenJDK feature in installer" )
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
set ( ${PROJECT_NAME}_BASE java-${${PROJECT_NAME}_MAJOR_VERSION}-openjdk${${PROJECT_NAME}_DEBUG_IMAGE_LABEL}-${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}.${${PROJECT_NAME}_BUILD}-${${PROJECT_NAME}_RPMBUILD}.windows.${${PROJECT_NAME}_VENDOR_LOWERCASE} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_IMAGE ${${PROJECT_NAME}_BASE}.x86_64 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SRCBUNDLE ${${PROJECT_NAME}_BASE}.src CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEBUGBUNDLE ${${PROJECT_NAME}_IMAGE}.debuginfo CACHE INTERNAL "" )

# copy and other helpers
set ( ${PROJECT_NAME}_RBCFLAGS /ndl /njh /njs /nc /ns /np CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RBCPOSTFIX ^& if errorlevel 1 if not errorlevel 2 exit 0 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_FONTS_SRC ${OJDKBUILD_DIR}/lookaside/dejavu-fonts CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_FONTS_DEST ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/lib/fonts CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_WIXGEN_JVM_OPTS -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Dcom.sun.xml.bind.v2.bytecode.ClassTailor.noOptimize=true CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SIGNER_JVM_OPTS -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 CACHE INTERNAL "" )

# dependencies
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/freetype )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/zlib )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/nss )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/giflib )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/libpng )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/libjpeg-turbo )
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
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/installer.json
        ${CMAKE_CURRENT_BINARY_DIR}/installer.json )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/jdk_registry_env.xsl
        ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl )

# targets

add_custom_command ( OUTPUT modules
        COMMAND if not exist modules ${OJDKBUILD_DIR}/tools/zip/unzip -qo modules.zip
        WORKING_DIRECTORY ${OJDKBUILD_DIR}/tools/bootjdk10/lib
        COMMENT "Preparing boot jdk ..." )

add_custom_target ( bootjdk DEPENDS modules )

add_custom_target ( builddir
        COMMAND if not exist ${PROJECT_NAME} mkdir ${PROJECT_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing build directory ..." )

add_custom_target ( cygwin
        COMMAND bash -c "rm -f /dev/fd"
        COMMAND bash -c "ln -s /proc/self/fd /dev/fd"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing Cygwin ..." )

add_custom_target ( tzdata
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${OJDKBUILD_DIR}/lookaside/java-11-openjdk/make/data/tzdata
                africa antarctica asia australasia backward etcetera europe factory iso3166.tab leapseconds northamerica
                pacificnew southamerica systemv zone.tab ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${OJDKBUILD_DIR}/lookaside/java-11-openjdk/make/data/tzdata
                VERSION ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Copying timezone data ..." )

add_custom_target ( icons
        COMMAND if exist icons rmdir /s /q icons
        COMMAND mkdir icons
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} icons icon.ico ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd icons && rename icon.ico awt.ico
        COMMAND (robocopy icons ${OJDKBUILD_DIR}/lookaside/java-11-openjdk/src/java.base/windows/native/launcher/icons
                ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} icons icon.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd icons && rename icon.png netx-icon.png
        COMMAND (robocopy icons ${OJDKBUILD_DIR}/lookaside/icedtea-web/netx/net/sourceforge/jnlp/resources
                netx-icon.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Copying icons ..." )

add_custom_command ( OUTPUT ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin/java.exe
        COMMAND if not exist spec.gmk
                cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash ${OJDKBUILD_DIR}/lookaside/java-11-openjdk/configure
                --disable-hotspot-gtest
                --disable-warnings-as-errors
                --enable-unlimited-crypto=yes
                --with-boot-jdk=${OJDKBUILD_DIR}/tools/bootjdk10
                --with-cacerts-file=${OJDKBUILD_DIR}/lookaside/ca-certificates/cacerts
                --with-debug-level=${${PROJECT_NAME}_DEBUG_LEVEL}
                --with-log=info
                --with-native-debug-symbols=external
                --with-version-build=${${PROJECT_NAME}_BUILD}
                --with-version-pre=${${PROJECT_NAME}_VENDOR_LOWERCASE}
                --with-version-opt="LTS"
                --with-num-cores=4
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash -c "make ${${PROJECT_NAME}_IMAGES_TARGET} JAVAC_FLAGS=-g"
        # deplibs
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin freetype.dll ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin ojdkbuild_giflib.dll ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin ojdkbuild_libjpeg-turbo.dll ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin ojdkbuild_libpng.dll ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin ojdkbuild_nss.dll ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS bootjdk
                builddir
                cygwin
                ojdkbuild_freetype
                ojdkbuild_zlib
                ojdkbuild_nss
                ojdkbuild_giflib
                ojdkbuild_libpng
                ojdkbuild_libjpeg-turbo
                icons
                tzdata
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Building OpenJDK ..." )
add_custom_target ( ${PROJECT_NAME} DEPENDS ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH}/bin/java.exe )

add_custom_target ( preimage
        # copy image
        COMMAND if exist ${${PROJECT_NAME}_IMAGE} rd /s /q ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_BOOTCYCLE_IMAGE_PATH} ${${PROJECT_NAME}_IMAGE} /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # remove demo
        COMMAND cd ${${PROJECT_NAME}_IMAGE} && rd /s /q demo
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
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS preimage
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image ..." )

add_custom_target ( image_jmc
        COMMAND (robocopy jmc/dist ${${PROJECT_NAME}_IMAGE}/missioncontrol /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS image jmc
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image with JMC ..." )

add_custom_target ( debuginfo
        COMMAND ${OJDKBUILD_DIR}/tools/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_DEBUGBUNDLE}.zip ${${PROJECT_NAME}_DEBUGBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_DEBUGBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating debuginfo bundle ..." )
if ( ${PROJECT_NAME}_ENABLE_JMC )
    add_dependencies ( debuginfo image_jmc )
else ( )
    add_dependencies ( debuginfo image )
endif ( )

add_custom_target ( zip
        COMMAND ${OJDKBUILD_DIR}/tools/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS debuginfo
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP bundle ..." )

add_custom_target ( zip_debug
        # deplibs
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin freetype.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin freetype.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin ojdkbuild_giflib.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin ojdkbuild_giflib.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin ojdkbuild_libjpeg-turbo.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin ojdkbuild_libjpeg-turbo.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin ojdkbuild_libpng.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin ojdkbuild_libpng.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin ojdkbuild_nss.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin ojdkbuild_nss.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}/lib/src.zip
        COMMAND ${OJDKBUILD_DIR}/tools/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS preimage
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP debug bundle ..." )

add_custom_target ( installer_descriptor
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                ${${PROJECT_NAME}_IMAGE}
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer.json
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        DEPENDS zip
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing installer descriptor ..." )

add_custom_target ( installer_descriptor_jmc
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.pre_jmc.wxs
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.pre_jmc_env.wxs
        COMMAND ${CMAKE_COMMAND} -E remove jmc_root.wxs
        COMMAND ${CMAKE_COMMAND} -E remove jmc_directory.xml
        COMMAND ${CMAKE_COMMAND} -E remove jmc_feature.xml
        COMMAND ${CMAKE_COMMAND} -E remove jmc_installer.xml
        COMMAND rename ${${PROJECT_NAME}_IMAGE}.wxs ${${PROJECT_NAME}_IMAGE}.pre_jmc.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                ${CMAKE_CURRENT_BINARY_DIR}/jmc/dist
                -c jmc/installer.json
                -o jmc_root.wxs
                -d jmc_directory.xml
                -f jmc_feature.xml
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                ${${PROJECT_NAME}_IMAGE}.pre_jmc.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jmc/installer.xsl
                -o ${${PROJECT_NAME}_IMAGE}.pre_jmc_env.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                ${${PROJECT_NAME}_IMAGE}.pre_jmc_env.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jmc/installer_env.xsl
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        DEPENDS jmc installer_descriptor
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing installer JMC descriptor ..." )

add_custom_target ( installer
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.wixobj
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.wixpdb
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.pre_registry.wxs
        COMMAND rename ${${PROJECT_NAME}_IMAGE}.wxs ${${PROJECT_NAME}_IMAGE}.pre_registry.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                ${${PROJECT_NAME}_IMAGE}.pre_registry.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${OJDKBUILD_DIR}/tools/wix/bin/candle -v -nologo ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${OJDKBUILD_DIR}/tools/wix/bin/light
                -nologo -sw1076 -ext WixUIExtension -ext WixUtilExtension
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_IMAGE}.wixobj
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.msi /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating MSI installer ..." )
if ( ${PROJECT_NAME}_ENABLE_JMC_INSTALLER )
    add_dependencies ( installer installer_descriptor_jmc )
else ( )
    add_dependencies ( installer installer_descriptor )
endif ( )

add_custom_target ( srcbundle
        COMMAND if exist ${${PROJECT_NAME}_SRCBUNDLE} rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/freetype ${${PROJECT_NAME}_SRCBUNDLE}/deps/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/giflib ${${PROJECT_NAME}_SRCBUNDLE}/deps/giflib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/jmc ${${PROJECT_NAME}_SRCBUNDLE}/deps/jmc /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/deps/libjpeg-turbo /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/libpng ${${PROJECT_NAME}_SRCBUNDLE}/deps/libpng /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/nss ${${PROJECT_NAME}_SRCBUNDLE}/deps/nss /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/zlib ${${PROJECT_NAME}_SRCBUNDLE}/deps/zlib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/freetype ${${PROJECT_NAME}_SRCBUNDLE}/external/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/giflib ${${PROJECT_NAME}_SRCBUNDLE}/external/giflib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/external/libjpeg-turbo /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/libpng ${${PROJECT_NAME}_SRCBUNDLE}/external/libpng /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/zlib ${${PROJECT_NAME}_SRCBUNDLE}/external/zlib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/ca-certificates ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/ca-certificates /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/dejavu-fonts ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/dejavu-fonts /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/freetype ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/giflib ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/giflib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/java-11-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/java-11-openjdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/libjpeg-turbo /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/libpng ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/libpng /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/nspr ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/nspr /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/nss ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/nss /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/nss-util ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/nss-util /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/tzdata /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/zlib ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/zlib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/upstream/jmc ${${PROJECT_NAME}_SRCBUNDLE}/upstream/jmc /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/cmake ${${PROJECT_NAME}_SRCBUNDLE}/resources/cmake /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/installer ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/ installer.json /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/scripts ${${PROJECT_NAME}_SRCBUNDLE}/resources/scripts /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/resources/tzdata /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/instres /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/src/java-11-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/src/java-11-openjdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR} ${${PROJECT_NAME}_SRCBUNDLE} LICENSE /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${OJDKBUILD_DIR}/tools/zip/zip.exe -qr0 ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND ${OJDKBUILD_DIR}/tools/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_SRCBUNDLE}.zip ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip
        COMMAND rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_SRCBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating sources bundle ..." )

add_custom_target ( devshell
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat bash
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Starting development shell session ..." )

