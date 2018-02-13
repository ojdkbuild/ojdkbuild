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
include ( ${OJDKBUILD_DIR}/resources/cmake/version_10.cmake )

# options
set ( ${PROJECT_NAME}_UNLIMITED_CRYPTO_FLAG "yes" CACHE STRING "Whether to enable unlimited cryptography" )
set ( ${PROJECT_NAME}_LOG_LEVEL "info" CACHE STRING "Logging verbosity during the build" )
set ( ${PROJECT_NAME}_BOOTSTRAP_BUILD OFF CACHE BOOL "Build bootstrap jdk first and then build the final one using it as bootjdk" )
set ( ${PROJECT_NAME}_32_BIT OFF CACHE BOOL "Build 32-bit binaries" )
set ( ${PROJECT_NAME}_DEST_DIR ${OJDKBUILD_DIR}/dist CACHE STRING "Destination directory" )
# zip bundle options
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "9" CACHE STRING "ZIP compress level" )
# installer options
set ( ${PROJECT_NAME}_INSTALLER_JDK_RELEASE "${${PROJECT_NAME}_MAJOR_VERSION}" CACHE STRING "JDK major version for installer" )
set ( ${PROJECT_NAME}_INSTALLER_VENDOR ${${PROJECT_NAME}_VENDOR} CACHE STRING "Installer vendor label" )
set ( ${PROJECT_NAME}_INSTALLER_VENDOR_DIRNAME ${${PROJECT_NAME}_VENDOR_DIRNAME} CACHE STRING "Installer vendor directory" )
set ( ${PROJECT_NAME}_INSTALLER_HELP_LINK "https://github.com/ojdkbuild" CACHE STRING "Installer help link" )
set ( ${PROJECT_NAME}_INSTALLER_PRODUCT_UUID "978ffd95-4c70-4856-a1f0-7c299b174083" CACHE STRING "Installer product UUID" )
set ( ${PROJECT_NAME}_INSTALLER_UPDATE_UUID "fad7c1d3-3936-4123-bf07-e929a6b4ed7b" CACHE STRING "Installer update UUID" )
set ( ${PROJECT_NAME}_INSTALLER_RESOURCES_PATH "${OJDKBUILD_DIR}/resources/installer/instres" CACHE STRING "Path to installer resources" )
set ( ${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS "" CACHE STRING "Additional options to pass to installer's linker" )
set ( ${PROJECT_NAME}_INSTALLER_JDK_FEATURE_DESCRIPTION "OpenJDK 10 runtime files." CACHE STRING "Description label of the OpenJDK feature in installer" )
set ( ${PROJECT_NAME}_INSTALLER_USE_FEATURE_TREE false CACHE STRING "Whether to use installer feature tree" )
# dev options
set ( ${PROJECT_NAME}_DEV_MODE OFF CACHE BOOL 
        "Whether to invoke 'bash' and give CLI to the developer instead of running configure and make in 'openjdk' target" )

# debug options
if ( CMAKE_BUILD_TYPE MATCHES "Release" )
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "release" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_IMAGE_LABEL "" CACHE INTERNAL "" )
elseif ( CMAKE_BUILD_TYPE MATCHES "Debug" )
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "slowdebug" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_IMAGE_LABEL "-debug" CACHE INTERNAL "" )
else ( )
    message ( FATAL_ERROR "Unsupported build type: [${CMAKE_BUILD_TYPE}]" )
endif ( )

# arch vars 
if ( ${PROJECT_NAME}_32_BIT )
    set ( ${PROJECT_NAME}_ARCH "x86" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_TARGET_BITS "32" CACHE INTERNAL "" )
else ( )
    set ( ${PROJECT_NAME}_ARCH "x86_64" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_TARGET_BITS "64" CACHE INTERNAL "" )
endif ( )

# image naming
# 1<major><major><update><update><update><build><build><build><release><release>
set ( ${PROJECT_NAME}_MONOTONIC_VERSION_NUMBER 1${${PROJECT_NAME}_MAJOR_VERSION}${${PROJECT_NAME}_UPDATE}0${${PROJECT_NAME}_RPMBUILD}0${${PROJECT_NAME}_BUILD} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE java-${${PROJECT_NAME}_MAJOR_VERSION}-openjdk${${PROJECT_NAME}_DEBUG_IMAGE_LABEL}-${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}-${${PROJECT_NAME}_RPMBUILD}.b${${PROJECT_NAME}_BUILD}.${${PROJECT_NAME}_MILESTONE}.windows CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEST_JDK_DIR ${CMAKE_CURRENT_BINARY_DIR}/java-10-openjdk CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BOOT_JDK_DIR ${CMAKE_CURRENT_BINARY_DIR}/java-10-openjdk-boot CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_IMAGE ${${PROJECT_NAME}_BASE}.${${PROJECT_NAME}_ARCH} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SRCBUNDLE ${${PROJECT_NAME}_BASE}.src CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEBUGBUNDLE ${${PROJECT_NAME}_IMAGE}.debuginfo CACHE INTERNAL "" )

# copy and other helpers
set ( ${PROJECT_NAME}_RBCFLAGS /nfl /ndl /njh /njs /nc /ns /np CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RBCPOSTFIX ^& if errorlevel 1 if not errorlevel 2 exit 0 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_TOOLS ${CMAKE_CURRENT_LIST_DIR}/../../tools CACHE INTERNAL "" )
        
# dependencies
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/freetype )

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
        
# shortcut vars
set ( ${PROJECT_NAME}_FONTS_SRC ${CMAKE_CURRENT_LIST_DIR}/../../lookaside/dejavu-fonts )
set ( ${PROJECT_NAME}_FONTS_DEST ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/lib/fonts )
        
# targets
add_custom_target ( ${PROJECT_NAME}
        # build
        COMMAND cmd.exe /c ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.bat
        COMMENT "Starting OpenJDK build ..." )
add_dependencies ( ${PROJECT_NAME} ojdkbuild_freetype ojdkbuild_zlib ojdkbuild_nss ojdkbuild_giflib ojdkbuild_libpng ojdkbuild_libjpeg-turbo )

add_custom_target ( preimage
        # copy image
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_DEST_JDK_DIR}/images/jdk ${${PROJECT_NAME}_IMAGE}
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
        COMMAND ${CMAKE_COMMAND} -E make_directory ${${PROJECT_NAME}_IMAGE}/bin/server
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
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
        COMMAND pushd ${${PROJECT_NAME}_IMAGE}\\bin && ${${PROJECT_NAME}_TOOLS}/zip/unzip.exe -q *.diz
        COMMAND pushd ${${PROJECT_NAME}_IMAGE}\\bin\\server && ${${PROJECT_NAME}_TOOLS}/zip/unzip.exe -q *.diz
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_IMAGE}/bin *.pdb ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_IMAGE}/bin *.map ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.diz /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}/lib/src.zip
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
        COMMENT "Creating ZIP image ..." )
add_dependencies ( zip debuginfo )

add_custom_target ( zip_debug
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP debug bundle ..." )
add_dependencies ( zip_debug image_debug )

add_custom_target ( installer
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${${PROJECT_NAME}_TOOLS}/bootjdk8/bin/java.exe 
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_IMAGE}
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer.json
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${${PROJECT_NAME}_TOOLS}/wix/bin/candle -v -nologo ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${${PROJECT_NAME}_TOOLS}/wix/bin/light 
                -v -nologo -sw1076 -ext WixUIExtension -ext WixUtilExtension
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_IMAGE}.wixobj
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.msi /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}		
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}        
        COMMENT "Creating MSI installer ..." )
add_dependencies ( installer zip )
        
add_custom_target ( srcbundle
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/freetype ${${PROJECT_NAME}_SRCBUNDLE}/deps/freetype /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/ca-certificates ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/ca-certificates /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/dejavu-fonts ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/dejavu-fonts /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/freetype ${${PROJECT_NAME}_SRCBUNDLE}/lookaside/freetype /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/upstream/jdk ${${PROJECT_NAME}_SRCBUNDLE}/upstream/jdk /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/cmake ${${PROJECT_NAME}_SRCBUNDLE}/resources/cmake /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/installer/ ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/ installer.json ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/scripts ${${PROJECT_NAME}_SRCBUNDLE}/resources/scripts /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/instres /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/src/java-10-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/src/java-10-openjdk /e ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/ ${${PROJECT_NAME}_SRCBUNDLE} LICENSE ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr0 ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_SRCBUNDLE}.zip ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_SRCBUNDLE}.solid.zip
        # COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_SRCBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}						
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating sources bundle ..." )
