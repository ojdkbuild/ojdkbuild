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

cmake_minimum_required ( VERSION 2.8.12 )

# project
set ( OJDKBUILD_DIR ${CMAKE_CURRENT_LIST_DIR}/../.. CACHE INTERNAL "" )
project ( openjdk NONE )
include ( ${OJDKBUILD_DIR}/resources/cmake/version_9.cmake )

# options
set ( ${PROJECT_NAME}_UNLIMITED_CRYPTO_FLAG "yes" CACHE STRING "Whether to enable unlimited cryptography" )
set ( ${PROJECT_NAME}_LOG_LEVEL "info" CACHE STRING "Logging verbosity during the build" )
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
# dev options
set ( ${PROJECT_NAME}_DEV_MODE OFF CACHE BOOL 
        "Whether to invoke 'bash' and give CLI to the developer instead of running configure and make in 'openjdk' target" )

# image naming
# 1<major><major><update><update><update><build><build><build><release><release>
set ( ${PROJECT_NAME}_MONOTONIC_VERSION_NUMBER 10${${PROJECT_NAME}_MAJOR_VERSION}${${PROJECT_NAME}_UPDATE}0${${PROJECT_NAME}_RPMBUILD}0${${PROJECT_NAME}_BUILD} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE java-${${PROJECT_NAME}_MAJOR_VERSION}-openjdk-${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}-${${PROJECT_NAME}_RPMBUILD}.b${${PROJECT_NAME}_BUILD}.${${PROJECT_NAME}_MILESTONE}.windows CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_IMAGE ${${PROJECT_NAME}_BASE}.x86_64 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SRCBUNDLE ${${PROJECT_NAME}_BASE}.src CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEBUGBUNDLE ${${PROJECT_NAME}_BASE}.debug CACHE INTERNAL "" )
        
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
set ( ${PROJECT_NAME}_TOOLS ${CMAKE_CURRENT_LIST_DIR}/../../tools )
        
# targets
add_custom_target ( ${PROJECT_NAME}
        # build
        COMMAND cmd.exe /c ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.bat
        # copy image
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                ${CMAKE_CURRENT_BINARY_DIR}/java-9-openjdk/images/jdk
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Starting OpenJDK build ..." )
add_dependencies ( ${PROJECT_NAME} ojdkbuild_freetype ojdkbuild_zlib ojdkbuild_nss ojdkbuild_giflib ojdkbuild_libpng ojdkbuild_libjpeg-turbo )
        
add_custom_target ( zip
        COMMAND ${${PROJECT_NAME}_TOOLS}/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP image ..." )
add_dependencies ( zip ${PROJECT_NAME} )

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
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}        
        COMMENT "Creating MSI installer ..." )
add_dependencies ( installer ${PROJECT_NAME} update_notifier_dist )
        
