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

# options
set ( ${PROJECT_NAME}_MILESTONE "ojdkbuild" CACHE STRING "Version string 'milestone' field" )
set ( ${PROJECT_NAME}_UPDATE "102" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_BUILD "14" CACHE STRING "Version string 'build' field" )
set ( ${PROJECT_NAME}_RPMBUILD "1" CACHE STRING "Build number in image name" )
set ( ${PROJECT_NAME}_UNLIMITED_CRYPTO_FLAG "yes" CACHE STRING "Whether to enable unlimited cryptography" )
set ( ${PROJECT_NAME}_LOG_LEVEL "info" CACHE STRING "Logging verbosity during the build" )
# zip bundle options
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "9" CACHE STRING "ZIP compress level" )
# installer options
set ( ${PROJECT_NAME}_INSTALLER_JDK_RELEASE "8" CACHE STRING "JDK major version for installer" )
set ( ${PROJECT_NAME}_INSTALLER_VENDOR "ojdkbuild open-source project" CACHE STRING "Installer vendor label" )
set ( ${PROJECT_NAME}_INSTALLER_VENDOR_DIRNAME "ojdkbuild" CACHE STRING "Installer vendor directory" )
set ( ${PROJECT_NAME}_INSTALLER_HELP_LINK "https://github.com/ojdkbuild" CACHE STRING "Installer help link" )
set ( ${PROJECT_NAME}_INSTALLER_PRODUCT_UUID "32fb128a-8b27-49cc-9609-d57a33529f4e" CACHE STRING "Installer product UUID" )
set ( ${PROJECT_NAME}_INSTALLER_UPDATE_UUID "d7b6cc21-8396-4848-84d4-5ca954c2f25d" CACHE STRING "Installer update UUID" )
set ( ${PROJECT_NAME}_INSTALLER_RESOURCES_PATH "${OJDKBUILD_DIR}/resources/installer/instres" CACHE STRING "Path to installer resources" )
set ( ${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS "" CACHE STRING "Additional options to pass to installer's linker" )
# dev options
set ( ${PROJECT_NAME}_DEV_MODE OFF CACHE BOOL 
        "Whether to invoke 'bash' and give CLI to the developer instead of running configure and make in 'openjdk' target" )
# debug options
if ( CMAKE_BUILD_TYPE MATCHES "Release" )
    set ( ${PROJECT_NAME}_DEBUG_SYMBOLS_FLAG "no" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "release" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_DLL_POSTFIX "" CACHE INTERNAL "" )
elseif ( CMAKE_BUILD_TYPE MATCHES "Debug" )
    set ( ${PROJECT_NAME}_DEBUG_SYMBOLS_FLAG "yes" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "slowdebug" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_DLL_POSTFIX "d" CACHE INTERNAL "" )
else ( )
    message ( FATAL_ERROR "Unsupported build type: [${CMAKE_BUILD_TYPE}]" )
endif ( )
        
# dependencies
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/freetype )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/zlib )
ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/nss )

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
set ( ${PROJECT_NAME}_IMAGE java-1.8.0-openjdk-1.8.0.${${PROJECT_NAME}_UPDATE}-${${PROJECT_NAME}_RPMBUILD}-${${PROJECT_NAME}_MILESTONE}.b${${PROJECT_NAME}_BUILD}.windows.x86_64 )
set ( ${PROJECT_NAME}_SRCBUNDLE java-1.8.0-openjdk-1.8.0.${${PROJECT_NAME}_UPDATE}-${${PROJECT_NAME}_RPMBUILD}-${${PROJECT_NAME}_MILESTONE}.b${${PROJECT_NAME}_BUILD}.windows.src )        
set ( ${PROJECT_NAME}_TZDATA_SRC ${OJDKBUILD_DIR}/lookaside/tzdata )
set ( ${PROJECT_NAME}_TZDATA_DEST ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/make/data/tzdata )
set ( ${PROJECT_NAME}_FONTS_SRC ${CMAKE_CURRENT_LIST_DIR}/../../lookaside/dejavu-fonts )
set ( ${PROJECT_NAME}_FONTS_DEST ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/jre/lib/fonts )
set ( ${PROJECT_NAME}_TOOLS ${CMAKE_CURRENT_LIST_DIR}/../../tools )        
        
# targets
add_custom_target ( ${PROJECT_NAME}
        # tzdata
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/africa       ${${PROJECT_NAME}_TZDATA_DEST}/africa
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/antarctica   ${${PROJECT_NAME}_TZDATA_DEST}/antarctica
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/asia         ${${PROJECT_NAME}_TZDATA_DEST}/asia
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/australasia  ${${PROJECT_NAME}_TZDATA_DEST}/australasia
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/backward     ${${PROJECT_NAME}_TZDATA_DEST}/backward
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/etcetera     ${${PROJECT_NAME}_TZDATA_DEST}/etcetera
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/europe       ${${PROJECT_NAME}_TZDATA_DEST}/europe
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/factory      ${${PROJECT_NAME}_TZDATA_DEST}/factory
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/iso3166.tab  ${${PROJECT_NAME}_TZDATA_DEST}/iso3166.tab
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/leapseconds  ${${PROJECT_NAME}_TZDATA_DEST}/leapseconds
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/northamerica ${${PROJECT_NAME}_TZDATA_DEST}/northamerica
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/pacificnew   ${${PROJECT_NAME}_TZDATA_DEST}/pacificnew
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/southamerica ${${PROJECT_NAME}_TZDATA_DEST}/southamerica
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/systemv      ${${PROJECT_NAME}_TZDATA_DEST}/systemv
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_TZDATA_SRC}/zone.tab     ${${PROJECT_NAME}_TZDATA_DEST}/zone.tab
        COMMAND ${CMAKE_COMMAND} -E copy ${OJDKBUILD_DIR}/resources/tzdata/VERSION ${${PROJECT_NAME}_TZDATA_DEST}/VERSION
        # build
        COMMAND cmd.exe /c ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.bat
        # copy image
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                ${CMAKE_CURRENT_LIST_DIR}/../../lookaside/java-1.8.0-openjdk/build/windows-x86_64-normal-server-${${PROJECT_NAME}_DEBUG_LEVEL}/images/j2sdk-image
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}
        # remove demo and sample
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}/demo
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}/sample
        # add fonts
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${${PROJECT_NAME}_FONTS_SRC}/ttf ${${PROJECT_NAME}_FONTS_DEST}
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_FONTS_SRC}/LICENSE ${${PROJECT_NAME}_FONTS_DEST}
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_FONTS_SRC}/AUTHORS ${${PROJECT_NAME}_FONTS_DEST}
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_FONTS_SRC}/README ${${PROJECT_NAME}_FONTS_DEST}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Starting OpenJDK build ..." )
add_dependencies ( ${PROJECT_NAME} ojdkbuild_freetype ojdkbuild_zlib ojdkbuild_nss )        
        
add_custom_target ( zip
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP image ..." )
        
add_custom_target ( installer
        COMMAND ${${PROJECT_NAME}_TOOLS}/bootjdk7/bin/java.exe 
                -jar ${${PROJECT_NAME}_TOOLS}/wixgen/wixgen.jar
                ${${PROJECT_NAME}_IMAGE}
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer.json
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${${PROJECT_NAME}_TOOLS}/wix/bin/candle -v -nologo ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND ${${PROJECT_NAME}_TOOLS}/wix/bin/light 
                -v -nologo -sw1076 -ext WixUIExtension 
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_IMAGE}.wixobj
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}        
        COMMENT "Creating MSI installer ..." )
        
add_custom_target ( srcbundle
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OJDKBUILD_DIR}/deps ${${PROJECT_NAME}_SRCBUNDLE}/deps
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OJDKBUILD_DIR}/lookaside ${${PROJECT_NAME}_SRCBUNDLE}/lookaside        
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OJDKBUILD_DIR}/resources ${${PROJECT_NAME}_SRCBUNDLE}/resources
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_SRCBUNDLE}/resources/checksums
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/instres
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_SRCBUNDLE}/resources/installer/instres
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OJDKBUILD_DIR}/src ${${PROJECT_NAME}_SRCBUNDLE}/src
        COMMAND ${CMAKE_COMMAND} -E copy ${OJDKBUILD_DIR}/LICENSE ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_SRCBUNDLE}.zip ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_SRCBUNDLE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating sources bundle ..." )
        
