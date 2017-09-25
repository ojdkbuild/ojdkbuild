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
include ( ${OJDKBUILD_DIR}/resources/cmake/version_8.cmake )

# options
set ( ${PROJECT_NAME}_UNLIMITED_CRYPTO_FLAG "yes" CACHE STRING "Whether to enable unlimited cryptography" )
set ( ${PROJECT_NAME}_LOG_LEVEL "info" CACHE STRING "Logging verbosity during the build" )
set ( ${PROJECT_NAME}_BOOTSTRAP_BUILD OFF CACHE BOOL "Build bootstrap jdk first and then build the final one using it as bootjdk" )
set ( ${PROJECT_NAME}_32_BIT OFF CACHE BOOL "Build 32-bit binaries" )
set ( ${PROJECT_NAME}_DEST_DIR ${OJDKBUILD_DIR}/dist CACHE STRING "Destination directory" )
set ( ${PROJECT_NAME}_ENABLE_OPENJFX OFF CACHE BOOL "Enable building OpenJFX" )
set ( ${PROJECT_NAME}_ENABLE_ICEDTEAWEB OFF CACHE BOOL "Enable building IcedTea-Web" )
# zip bundle options
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "9" CACHE STRING "ZIP compress level" )
# installer options
set ( ${PROJECT_NAME}_INSTALLER_JDK_RELEASE "${${PROJECT_NAME}_MAJOR_VERSION}" CACHE STRING "JDK major version for installer" )
set ( ${PROJECT_NAME}_INSTALLER_VENDOR ${${PROJECT_NAME}_VENDOR} CACHE STRING "Installer vendor label" )
set ( ${PROJECT_NAME}_INSTALLER_VENDOR_DIRNAME ${${PROJECT_NAME}_VENDOR_DIRNAME} CACHE STRING "Installer vendor directory" )
set ( ${PROJECT_NAME}_INSTALLER_HELP_LINK "https://github.com/ojdkbuild" CACHE STRING "Installer help link" )
set ( ${PROJECT_NAME}_INSTALLER_PRODUCT_UUID "32fb128a-8b27-49cc-9609-d57a33529f4e" CACHE STRING "Installer product UUID" )
set ( ${PROJECT_NAME}_INSTALLER_UPDATE_UUID "d7b6cc21-8396-4848-84d4-5ca954c2f25d" CACHE STRING "Installer update UUID" )
set ( ${PROJECT_NAME}_INSTALLER_RESOURCES_PATH "${OJDKBUILD_DIR}/resources/installer/instres" CACHE STRING "Path to installer resources" )
set ( ${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS "" CACHE STRING "Additional options to pass to installer's linker" )
set ( ${PROJECT_NAME}_INSTALLER_JDK_FEATURE_DESCRIPTION "OpenJDK 8 runtime files." CACHE STRING "Description label of the OpenJDK feature in installer" )
set ( ${PROJECT_NAME}_INSTALLER_JRE_DIR "jre\\\\" CACHE STRING "JRE dir to use for registry keys" )
# dev options
set ( ${PROJECT_NAME}_DEV_MODE OFF CACHE BOOL 
        "Whether to invoke 'bash' and give CLI to the developer instead of running configure and make in 'openjdk' target" )

# debug options
if ( CMAKE_BUILD_TYPE MATCHES "Release" )
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "release" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_DLL_POSTFIX "" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_IMAGE_LABEL "" CACHE INTERNAL "" )
elseif ( CMAKE_BUILD_TYPE MATCHES "Debug" )
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "slowdebug" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_DLL_POSTFIX "d" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_IMAGE_LABEL "-debug" CACHE INTERNAL "" )
else ( )
    message ( FATAL_ERROR "Unsupported build type: [${CMAKE_BUILD_TYPE}]" )
endif ( )

# arch vars 
if ( ${PROJECT_NAME}_32_BIT )
    set ( ${PROJECT_NAME}_ARCH "x86" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_TARGET_BITS "32" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_VCTOOLS_PATH "" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_MSVCR_PATH "i586" CACHE INTERNAL "" )
else ( )
    set ( ${PROJECT_NAME}_ARCH "x86_64" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_TARGET_BITS "64" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_VCTOOLS_PATH "x86_amd64/" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_MSVCR_PATH "amd64" CACHE INTERNAL "" )
endif ( )

# image naming
# 1<major><major><update><update><update><build><build><build><release><release>
set ( ${PROJECT_NAME}_MONOTONIC_VERSION_NUMBER 10${${PROJECT_NAME}_MAJOR_VERSION}${${PROJECT_NAME}_UPDATE}0${${PROJECT_NAME}_RPMBUILD}0${${PROJECT_NAME}_BUILD} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE java-1.${${PROJECT_NAME}_MAJOR_VERSION}.0-openjdk${${PROJECT_NAME}_DEBUG_IMAGE_LABEL}-1.${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}-${${PROJECT_NAME}_RPMBUILD}.b${${PROJECT_NAME}_BUILD}.${${PROJECT_NAME}_MILESTONE}.windows CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEST_JDK_DIR ${CMAKE_CURRENT_BINARY_DIR}/java-1.8.0-openjdk CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BOOT_JDK_DIR ${CMAKE_CURRENT_BINARY_DIR}/java-1.8.0-openjdk-boot CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_IMAGE ${${PROJECT_NAME}_BASE}.${${PROJECT_NAME}_ARCH} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SRCBUNDLE ${${PROJECT_NAME}_BASE}.src CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_TESTBUNDLE ${${PROJECT_NAME}_BASE}.test CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEBUGBUNDLE ${${PROJECT_NAME}_IMAGE}.debuginfo CACHE INTERNAL "" )

# copy and other helpers
set ( ${PROJECT_NAME}_RBCFLAGS /nfl /ndl /njh /njs /nc /ns /np CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RBCPOSTFIX ^& if errorlevel 1 if not errorlevel 2 exit 0 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_TOOLS ${CMAKE_CURRENT_LIST_DIR}/../../tools CACHE INTERNAL "" )

# dependencies
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/freetype )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/zlib )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/nss )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/giflib )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/libpng )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/libjpeg-turbo )
# update notifier
add_subdirectory ( ${OJDKBUILD_DIR}/contrib/update-notifier update_notifier )
# openjfx
if ( ${PROJECT_NAME}_ENABLE_OPENJFX ) 
    add_subdirectory ( ${OJDKBUILD_DIR}/deps/openjfx openjfx )
endif ( )
# icedteaweb
if ( ${PROJECT_NAME}_ENABLE_ICEDTEAWEB ) 
    add_subdirectory ( ${OJDKBUILD_DIR}/deps/icedtea-web icedtea_web )
endif ( )

# resources
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/configure-and-make.bat
        ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.bat 
        NEWLINE_STYLE WIN32 )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/configure-and-make.sh
        ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.sh
        NEWLINE_STYLE UNIX )
configure_file ( ${OJDKBUILD_DIR}/resources/installer/installer.json
        ${CMAKE_CURRENT_BINARY_DIR}/installer.json
        NEWLINE_STYLE UNIX )

# shorcut vars
set ( ${PROJECT_NAME}_FONTS_SRC ${CMAKE_CURRENT_LIST_DIR}/../../lookaside/dejavu-fonts )
set ( ${PROJECT_NAME}_FONTS_DEST ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/jre/lib/fonts )

# targets
add_custom_target ( ${PROJECT_NAME}
        # tzdata
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/make/data/tzdata
                africa antarctica asia australasia backward etcetera europe factory iso3166.tab leapseconds northamerica
                pacificnew southamerica systemv zone.tab ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/make/data/tzdata 
                VERSION ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # icon
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/src/windows/resource/icons
                icon.ico ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # build
        COMMAND cmd.exe /c ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.bat
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Starting OpenJDK build ..." )
add_dependencies ( ${PROJECT_NAME} ojdkbuild_freetype ojdkbuild_zlib ojdkbuild_nss ojdkbuild_giflib ojdkbuild_libpng ojdkbuild_libjpeg-turbo )

add_custom_target ( preimage
        # copy image
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_DEST_JDK_DIR}/images/j2sdk-image ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}
                /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # remove demo and sample
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}/demo
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}/sample
        # add fonts
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC}/ttf ${${PROJECT_NAME}_FONTS_DEST} ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} LICENSE ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} AUTHORS ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_FONTS_SRC} ${${PROJECT_NAME}_FONTS_DEST} README ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating preliminary image ..." )
add_dependencies ( preimage ${PROJECT_NAME} )

add_custom_target ( image
        # extract debuginfo
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_DEBUGBUNDLE}
        COMMAND ${CMAKE_COMMAND} -E remove_directory diz
        COMMAND ${CMAKE_COMMAND} -E make_directory ${${PROJECT_NAME}_IMAGE}/jre/bin/server
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND pushd ${${PROJECT_NAME}_DEBUGBUNDLE} && ${${PROJECT_NAME}_TOOLS}/zip/unzip.exe -q *.diz
        COMMAND (robocopy ${${PROJECT_NAME}_DEBUGBUNDLE}/ diz/ *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.pdb ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.map ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image ..." )
add_dependencies ( image preimage )

add_custom_target ( image_debug
        # unzip debuginfo
        COMMAND ${CMAKE_COMMAND} -E remove_directory diz
        COMMAND pushd ${${PROJECT_NAME}_IMAGE}\\jre\\bin && ${${PROJECT_NAME}_TOOLS}/zip/unzip.exe -q *.diz
        COMMAND pushd ${${PROJECT_NAME}_IMAGE}\\jre\\bin\\server && ${${PROJECT_NAME}_TOOLS}/zip/unzip.exe -q *.diz
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_IMAGE}/jre/bin *.pdb ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_IMAGE}/jre/bin *.map ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/jre/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}/src.zip
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating debug image ..." )
add_dependencies ( image_debug preimage )

add_custom_target ( debuginfo
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_DEBUGBUNDLE}.zip ${${PROJECT_NAME}_DEBUGBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_DEBUGBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating debuginfo bundle ..." )
add_dependencies ( debuginfo image )

add_custom_target ( zip
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP bundle ..." )
add_dependencies ( zip debuginfo )

add_custom_target ( zip_debug
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP debug bundle ..." )
add_dependencies ( zip_debug image_debug )

add_custom_target ( installer
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.pretransform.wxs
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe
                -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_IMAGE}
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer.json
                -o ${${PROJECT_NAME}_IMAGE}.pretransform.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe
                -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_IMAGE}.pretransform.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/update_notifier/installer.xsl
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${${PROJECT_NAME}_TOOLS}/wix/bin/candle -v -nologo ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${${PROJECT_NAME}_TOOLS}/wix/bin/light 
                -v -nologo -sw1076 -ext WixUIExtension -ext WixUtilExtension
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_IMAGE}.wixobj
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.msi /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating MSI installer ..." )
add_dependencies ( installer zip update_notifier_dist )

add_custom_target ( srcbundle
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/curl ${${PROJECT_NAME}_SRCBUNDLE}/deps/curl /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/freetype ${${PROJECT_NAME}_SRCBUNDLE}/deps/freetype /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/giflib ${${PROJECT_NAME}_SRCBUNDLE}/deps/giflib /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/jansson ${${PROJECT_NAME}_SRCBUNDLE}/deps/jansson /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/deps/libjpeg-turbo /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/libpng ${${PROJECT_NAME}_SRCBUNDLE}/deps/libpng /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/nss ${${PROJECT_NAME}_SRCBUNDLE}/deps/nss /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/openssl ${${PROJECT_NAME}_SRCBUNDLE}/deps/openssl /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/popt ${${PROJECT_NAME}_SRCBUNDLE}/deps/popt /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/zlib ${${PROJECT_NAME}_SRCBUNDLE}/deps/zlib /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/ca-certificates ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/ca-certificates /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/curl ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/curl /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/dejavu-fonts ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/dejavu-fonts /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/freetype ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/freetype /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/giflib ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/giflib /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/jansson ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/jansson /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/java-1.8.0-openjdk /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/libjpeg-turbo /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/libpng ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/libpng /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/nspr ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/nspr /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/nss ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/nss /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/nss-util ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/nss-util /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/openssl ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/openssl /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/popt ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/popt /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/tzdata /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/zlib ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/zlib /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/cmake ${${PROJECT_NAME}_SRCBUNDLE}/resources/cmake /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/installer ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/ installer.json ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/scripts ${${PROJECT_NAME}_SRCBUNDLE}/resources/scripts /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/resources/tzdata /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/instres /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/src/java-1.8.0-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/src/java-1.8.0-openjdk /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR} ${${PROJECT_NAME}_SRCBUNDLE} LICENSE ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr0 ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_SRCBUNDLE}.zip ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip
        # COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_SRCBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating sources bundle ..." )

add_custom_target ( testbundle
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/hotspot/test ${${PROJECT_NAME}_TESTBUNDLE}/hotspot/test /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/test ${${PROJECT_NAME}_TESTBUNDLE}/jdk/test /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/langtools/test ${${PROJECT_NAME}_TESTBUNDLE}/langtools/test /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/nashorn/test ${${PROJECT_NAME}_TESTBUNDLE}/nashorn/test /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_TESTBUNDLE}.zip ${${PROJECT_NAME}_TESTBUNDLE}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr0 ${${PROJECT_NAME}_TESTBUNDLE}.solid.zip ${${PROJECT_NAME}_TESTBUNDLE}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_TESTBUNDLE}.zip ${${PROJECT_NAME}_TESTBUNDLE}.solid.zip
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_TESTBUNDLE}.solid.zip
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_TESTBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating test bundle ..." )

