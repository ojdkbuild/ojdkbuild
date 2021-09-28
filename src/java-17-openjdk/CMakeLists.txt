# Copyright 2021, akashche at redhat.com
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
set ( ${PROJECT_NAME}_FEATURE "17" CACHE STRING "Version string 'feature' field" )
set ( ${PROJECT_NAME}_INTERIM "0" CACHE STRING "Version string 'interim' field" )
set ( ${PROJECT_NAME}_UPDATE "0" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_PATCH "0" CACHE STRING "Version string 'patch' field" )
set ( ${PROJECT_NAME}_BUILD "33" CACHE STRING "Version string 'build' field" )
set ( ${PROJECT_NAME}_RPMBUILD "0" CACHE STRING "Build number in image name" )

# options
set ( ${PROJECT_NAME}_ENABLE_EA OFF CACHE BOOL "Add 'Early Access' label to version string and artifact names" )
set ( ${PROJECT_NAME}_DEST_DIR ${OJDKBUILD_DIR}/dist CACHE STRING "Destination directory" )
set ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE OFF CACHE BOOL "Enable bootcycle build" )
set ( ${PROJECT_NAME}_ENABLE_JMC ON CACHE BOOL "Enable JDK Mission Control build" )
set ( ${PROJECT_NAME}_ENABLE_CLEANUP OFF CACHE BOOL "Delete temporary build files before creating the installer" )

# zip bundle options
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "9" CACHE STRING "ZIP compress level" )

# vendor options
set ( ${PROJECT_NAME}_VENDOR_NAME "ojdkbuild" CACHE STRING "Value for 'java.vendor' property" )
set ( ${PROJECT_NAME}_VENDOR_URL "https://github.com/ojdkbuild" CACHE STRING "Value for 'java.vendor.url' property" )
set ( ${PROJECT_NAME}_VENDOR_BUG_URL "https://github.com/ojdkbuild/ojdkbuild/issues" CACHE STRING "Value for 'java.vendor.url.bug' property" )

# installer options
set ( ${PROJECT_NAME}_INSTALLER_HELP_LINK "https://github.com/ojdkbuild" CACHE STRING "Installer help link" )
set ( ${PROJECT_NAME}_INSTALLER_UPDATE_UUID "7ab0f3c8-0264-4170-a46d-a0b28108bf3f" CACHE STRING "Installer update UUID" )
set ( ${PROJECT_NAME}_INSTALLER_JRE_UPDATE_UUID "ff89264a-df04-4858-877c-8fdf947f9dd6" CACHE STRING "JRE Installer update UUID" )
set ( ${PROJECT_NAME}_INSTALLER_RESOURCES_PATH "${OJDKBUILD_DIR}/resources/installer/instres" CACHE STRING "Path to installer resources" )

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
    set ( ${PROJECT_NAME}_DEBUG_LEVEL "fastdebug" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_DEBUG_IMAGE_LABEL "-debug" CACHE INTERNAL "" )
else ( )
    message ( FATAL_ERROR "Unsupported build type: [${CMAKE_BUILD_TYPE}]" )
endif ( )

# bootcycle vars
if ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE )
    set ( ${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/bootcycle-build/images" CACHE INTERNAL "" )
else ( )
    set ( ${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/images" CACHE INTERNAL "" )
endif ( )

# boot jdk path
set ( ${PROJECT_NAME}_BOOT_JDK "${OJDKBUILD_DIR}/tools/bootjdk16" CACHE INTERNAL "" )

# EA options
if ( ${PROJECT_NAME}_ENABLE_EA )
    set ( ${PROJECT_NAME}_EA_LABEL ".ea" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_EA_DESIGNATOR "ea" CACHE INTERNAL "" )
endif ( )

# image naming
set ( ${PROJECT_NAME}_EXE_VERSION "${${PROJECT_NAME}_FEATURE},${${PROJECT_NAME}_INTERIM}${${PROJECT_NAME}_UPDATE}${${PROJECT_NAME}_PATCH},${${PROJECT_NAME}_BUILD},${${PROJECT_NAME}_RPMBUILD}" CACHE INTERNAL "EXE version field" )
set ( ${PROJECT_NAME}_FILE_VERSION "${${PROJECT_NAME}_FEATURE}.${${PROJECT_NAME}_INTERIM}${${PROJECT_NAME}_UPDATE}${${PROJECT_NAME}_PATCH}.${${PROJECT_NAME}_BUILD}.${${PROJECT_NAME}_RPMBUILD}" CACHE INTERNAL "File version field" )
set ( ${PROJECT_NAME}_PREFIX java-${${PROJECT_NAME}_FEATURE}-openjdk${${PROJECT_NAME}_DEBUG_IMAGE_LABEL} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_NVR ${${PROJECT_NAME}_FEATURE}.${${PROJECT_NAME}_INTERIM}.${${PROJECT_NAME}_UPDATE}.${${PROJECT_NAME}_PATCH}.${${PROJECT_NAME}_BUILD}-${${PROJECT_NAME}_RPMBUILD}${${PROJECT_NAME}_EA_LABEL} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_IMAGE ${${PROJECT_NAME}_PREFIX}-${${PROJECT_NAME}_NVR}.win.x86_64 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_JRE_IMAGE ${${PROJECT_NAME}_PREFIX}-${${PROJECT_NAME}_NVR}.jre.win.x86_64 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SRCBUNDLE ${${PROJECT_NAME}_PREFIX}-${${PROJECT_NAME}_NVR}.src CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_TESTSRCBUNDLE ${${PROJECT_NAME}_PREFIX}-${${PROJECT_NAME}_NVR}.testsrc CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEBUGBUNDLE ${${PROJECT_NAME}_PREFIX}-${${PROJECT_NAME}_NVR}.win.x86_64.debuginfo CACHE INTERNAL "" )

# copy and other helpers
set ( ${PROJECT_NAME}_RBCFLAGS /ndl /njh /njs /nc /ns /np CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RBCPOSTFIX ^& if errorlevel 1 if not errorlevel 2 exit 0 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RUN_SCRIPTING_TASK cmd /c ${CMAKE_CURRENT_BINARY_DIR}/st_env.bat ${OJDKBUILD_DIR}/contrib/scripting-tasks/bin/rhino.bat CACHE INTERNAL "" )

# dependencies
# scripting-tasks rhino
add_subdirectory ( ${OJDKBUILD_DIR}/deps/rhino/scripting_tasks ${CMAKE_CURRENT_BINARY_DIR}/st_rhino )
# native
set ( STATICLIB_TOOLCHAIN windows_amd64_msvc CACHE INTERNAL "" )
# JDK Mission Control
if ( ${PROJECT_NAME}_ENABLE_JMC )
    if ( NOT DEFINED jmc_JAVA_HOME )
        set ( jmc_JAVA_HOME ${OJDKBUILD_DIR}/tools/jmcjdk11 CACHE STRING "Path to jdk to use for building JMC" )
    endif ( )
    ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/jmc jmc )
endif ( )

# resources
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/env.bat
        ${CMAKE_CURRENT_BINARY_DIR}/env.bat )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/st_env.bat
        ${CMAKE_CURRENT_BINARY_DIR}/st_env.bat )
configure_file ( ${OJDKBUILD_DIR}/resources/changelog/NEWS-17.txt
        ${CMAKE_CURRENT_BINARY_DIR}/NEWS
        NEWLINE_STYLE CRLF )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/installer.json
        ${CMAKE_CURRENT_BINARY_DIR}/installer.json )

# targets
add_custom_target ( bootjdk )

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
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${OJDKBUILD_DIR}/lookaside/java-17-openjdk/make/data/tzdata
                africa antarctica asia australasia backward etcetera europe factory iso3166.tab leapseconds northamerica
                pacificnew southamerica systemv zone.tab ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${OJDKBUILD_DIR}/lookaside/java-17-openjdk/make/data/tzdata
                VERSION ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Copying timezone data ..." )

add_custom_target ( icons
        COMMAND if exist icons rmdir /s /q icons
        COMMAND mkdir icons
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} icons icon.ico ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd icons && rename icon.ico awt.ico
        COMMAND (robocopy icons ${OJDKBUILD_DIR}/lookaside/java-17-openjdk/src/java.base/windows/native/launcher/icons
                ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} icons icon.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${OJDKBUILD_DIR}/lookaside/java-17-openjdk/src/java.desktop/windows/classes/com/sun/java/swing/plaf/windows/icons
                JavaCup32.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${OJDKBUILD_DIR}/lookaside/java-17-openjdk/src/java.desktop/share/classes/javax/swing/plaf/basic/icons
                JavaCup16.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Copying icons ..." )

add_custom_command ( OUTPUT ${${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH}/jdk/bin/java.exe
        COMMAND if not exist spec.gmk
                cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash ${OJDKBUILD_DIR}/lookaside/java-17-openjdk/configure
                --disable-warnings-as-errors
                --with-boot-jdk=${${PROJECT_NAME}_BOOT_JDK}
                --with-cacerts-file=${OJDKBUILD_DIR}/lookaside/ca-certificates/cacerts
                --with-vcruntime-1-dll=${OJDKBUILD_DIR}/tools/toolchain/vs2019bt_16113/VC/Redist/MSVC/14.29.30133/x64/Microsoft.VC142.CRT/vcruntime140_1.dll
                --with-ucrt-dll-dir=${OJDKBUILD_DIR}/tools/toolchain/sdk10_19041/Redist/10.0.19041.0/ucrt/DLLs/x64
                --with-debug-level=${${PROJECT_NAME}_DEBUG_LEVEL}
                --with-log=info
                --with-native-debug-symbols=external
                --with-version-build=${${PROJECT_NAME}_BUILD}
                --with-version-pre=${${PROJECT_NAME}_EA_DESIGNATOR}
                --with-version-opt=LTS
                --with-vendor-version-string=21.9
                --with-vendor-name="${${PROJECT_NAME}_VENDOR_NAME}"
                --with-vendor-url=${${PROJECT_NAME}_VENDOR_URL}
                --with-vendor-bug-url=${${PROJECT_NAME}_VENDOR_BUG_URL}
                --with-vendor-vm-bug-url=${${PROJECT_NAME}_VENDOR_BUG_URL}
                --with-jtreg=${OJDKBUILD_DIR}/tools/jtreg60_6583a8c
                --with-num-cores=4
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash -c "make ${${PROJECT_NAME}_IMAGES_TARGET}"
        DEPENDS builddir
                cygwin
                icons
                tzdata
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Building OpenJDK ..." )
add_custom_target ( ${PROJECT_NAME} DEPENDS ${${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH}/jdk/bin/java.exe )

add_custom_target ( preimage
        # copy image
        COMMAND if exist ${${PROJECT_NAME}_IMAGE} rd /s /q ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH}/jdk ${${PROJECT_NAME}_IMAGE} /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # copy jre
        COMMAND if exist ${${PROJECT_NAME}_JRE_IMAGE} rd /s /q ${${PROJECT_NAME}_JRE_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH}/jre ${${PROJECT_NAME}_JRE_IMAGE} /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE} NEWS ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # java.exe debuginfo
        COMMAND if exist diz_java_exe rd /s /q diz_java_exe
        COMMAND (robocopy openjdk/jdk/bin diz_java_exe java.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy openjdk/jdk/bin diz_java_exe java.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd diz_java_exe && rename java.map java_EXE.map
        COMMAND cd diz_java_exe && rename java.pdb java_EXE.pdb
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
        COMMAND if exist ${${PROJECT_NAME}_DEBUGBUNDLE} rd /s /q ${${PROJECT_NAME}_DEBUGBUNDLE}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${${PROJECT_NAME}_IMAGE}/bin/server
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.pdb /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin ${${PROJECT_NAME}_DEBUGBUNDLE} *.map /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.pdb /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}/bin/server ${${PROJECT_NAME}_DEBUGBUNDLE} *.map /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy bin/ ${${PROJECT_NAME}_DEBUGBUNDLE}/ *.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # remove jre debuginfo
        COMMAND if exist diz_jre rd /s /q diz_jre
        COMMAND (robocopy ${${PROJECT_NAME}_JRE_IMAGE}/bin diz_jre *.pdb /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_JRE_IMAGE}/bin diz_jre *.map /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_JRE_IMAGE}/bin/server diz_jre *.pdb /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_JRE_IMAGE}/bin/server diz_jre *.map /mov /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND rd /s /q diz_jre
        # java.exe debuginfo
        COMMAND (robocopy diz_java_exe ${${PROJECT_NAME}_DEBUGBUNDLE} java_EXE.map ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy diz_java_exe ${${PROJECT_NAME}_DEBUGBUNDLE} java_EXE.pdb ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image ..." )

if ( ${PROJECT_NAME}_ENABLE_CLEANUP )
    add_dependencies ( image preimage_cleanup )
else ( )
    add_dependencies ( image preimage )
endif ( )

add_custom_target ( image_jmc
        COMMAND ${CMAKE_COMMAND} -E remove jmc/dist/msvcp140.dll
        COMMAND (robocopy ${OJDKBUILD_DIR}/tools/toolchain/vs2019bt_16113/VC/Redist/MSVC/14.29.30133/x64/Microsoft.VC142.CRT
                jmc/dist msvcp140.dll /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy jmc/dist ${${PROJECT_NAME}_IMAGE}/missioncontrol /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS image jmc
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image with JMC ..." )

add_custom_target ( debuginfo
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${${PROJECT_NAME}_DEBUGBUNDLE} ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_DEBUGBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_DEBUGBUNDLE}.zip
        DEPENDS st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating debuginfo bundle ..." )
if ( ${PROJECT_NAME}_ENABLE_JMC )
    add_dependencies ( debuginfo image_jmc )
else ( )
    add_dependencies ( debuginfo image )
endif ( )

add_custom_target ( zip
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${${PROJECT_NAME}_IMAGE} ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.zip
        # jre
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${${PROJECT_NAME}_JRE_IMAGE} ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_JRE_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_JRE_IMAGE}.zip
        DEPENDS debuginfo
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP bundle ..." )

add_custom_target ( zip_debug
        # deplibs
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin freetype.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${${PROJECT_NAME}_IMAGE}/bin freetype.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${CMAKE_COMMAND} -E remove ${${PROJECT_NAME}_IMAGE}/lib/src.zip
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${${PROJECT_NAME}_IMAGE} ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.zip
        DEPENDS st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating ZIP debug bundle ..." )

if ( ${PROJECT_NAME}_ENABLE_CLEANUP )
    add_dependencies ( zip_debug preimage_cleanup )
else ( )
    add_dependencies ( zip_debug preimage )
endif ( )

add_custom_target ( installer_bundle
        COMMAND if exist ${${PROJECT_NAME}_IMAGE}.installer_bundle rd /s /q ${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE} ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_JRE_IMAGE} ${${PROJECT_NAME}_IMAGE}.installer_bundle/jre /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && mkdir msi-installer
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} msi-descriptors
                ${OJDKBUILD_DIR}/lookaside/java-17-openjdk/make/data/msi-installer/jdk.xml
                installer.json
                ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer/${${PROJECT_NAME}_IMAGE}.wxs
                ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer/${${PROJECT_NAME}_JRE_IMAGE}.wxs
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer && mkdir resources
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH}
                ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer/resources
                greetings_banner.bmp /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer/resources && rename greetings_banner.bmp greetings.bmp
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH}
                ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer/resources
                top_banner.bmp /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer/resources && rename top_banner.bmp top.bmp
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH}
                ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer/resources
                icon.ico /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH}
                ${${PROJECT_NAME}_IMAGE}.installer_bundle/msi-installer/resources
                LICENSE.rtf /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.installer_bundle.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle.zip
        DEPENDS zip
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing MSI installer bundle ..." )

add_custom_target ( installer
        COMMAND if exist i rd /s /q i
        COMMAND rename ${${PROJECT_NAME}_IMAGE}.installer_bundle i
        COMMAND cd i/msi-installer && ${OJDKBUILD_DIR}/tools/wix/bin/candle -v -nologo -arch x64 ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND cd i/msi-installer && ${OJDKBUILD_DIR}/tools/wix/bin/light
                -nologo -sw1076 -ext WixUIExtension -ext WixUtilExtension
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_IMAGE}.wixobj
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/i/msi-installer ${${PROJECT_NAME}_DEST_DIR}
                ${${PROJECT_NAME}_IMAGE}.msi /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.msi
        # jre
        COMMAND cd i/msi-installer && ${OJDKBUILD_DIR}/tools/wix/bin/candle -v -nologo -arch x64 ${${PROJECT_NAME}_JRE_IMAGE}.wxs
        COMMAND cd i/msi-installer && ${OJDKBUILD_DIR}/tools/wix/bin/light
                -nologo -sw1076 -ext WixUIExtension -ext WixUtilExtension
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_JRE_IMAGE}.wixobj
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/i/msi-installer ${${PROJECT_NAME}_DEST_DIR}
                ${${PROJECT_NAME}_JRE_IMAGE}.msi /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_JRE_IMAGE}.msi
        DEPENDS installer_bundle
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating MSI installer ..." )

add_custom_target ( srcbundle
        COMMAND if exist ${${PROJECT_NAME}_SRCBUNDLE} rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND mkdir ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND cd ${${PROJECT_NAME}_SRCBUNDLE} && mkdir windows
        COMMAND $ENV{GIT_HOME}/bin/git -C ${OJDKBUILD_DIR}/lookaside/java-17-openjdk format-patch origin/lookaside -o ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_SRCBUNDLE}/windows/patches
        COMMAND (robocopy ${OJDKBUILD_DIR}/contrib/local-cleaner ${${PROJECT_NAME}_SRCBUNDLE}/windows/contrib/local-cleaner /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/contrib/ojdkbuild-utils ${${PROJECT_NAME}_SRCBUNDLE}/windows/contrib/ojdkbuild-utils /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/jmc ${${PROJECT_NAME}_SRCBUNDLE}/windows/deps/jmc /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/popt ${${PROJECT_NAME}_SRCBUNDLE}/windows/external/popt /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/ca-certificates ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/ca-certificates /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/popt ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/popt /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/tzdata /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/buildres ${${PROJECT_NAME}_SRCBUNDLE}/windows/resources/buildres /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/cmake ${${PROJECT_NAME}_SRCBUNDLE}/windows/resources/cmake /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/windows/resources/tzdata /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/src/java-17-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/windows/src/java-17-openjdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/upstream/jmc ${${PROJECT_NAME}_SRCBUNDLE}/windows/upstream/jmc /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_SRCBUNDLE}/windows/resources/installer/instres /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR} ${${PROJECT_NAME}_SRCBUNDLE} LICENSE /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${${PROJECT_NAME}_SRCBUNDLE} ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_SRCBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating sources bundle ..." )

add_custom_target ( test_srcbundle
        COMMAND if exist ${${PROJECT_NAME}_TESTSRCBUNDLE} rd /s /q ${${PROJECT_NAME}_TESTSRCBUNDLE}
        COMMAND mkdir ${${PROJECT_NAME}_TESTSRCBUNDLE}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/java-17-openjdk/test ${${PROJECT_NAME}_TESTSRCBUNDLE} /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-solid ${${PROJECT_NAME}_TESTSRCBUNDLE} ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND rd /s /q ${${PROJECT_NAME}_TESTSRCBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_TESTSRCBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating test sources bundle ..." )

add_custom_target ( test_image
        COMMAND if exist ${${PROJECT_NAME}_IMAGE}.test rd /s /q ${${PROJECT_NAME}_IMAGE}.test
        COMMAND cd ${PROJECT_NAME} && cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat bash -c "make test-image"
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/images/test ${${PROJECT_NAME}_IMAGE}.test /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${${PROJECT_NAME}_IMAGE}.test ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.test.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.test.zip
        DEPENDS st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating test-image ..." )

add_custom_target ( devshell
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat bash
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Starting development shell session ..." )

add_custom_target ( msi_checks
        COMMAND if exist msi_checks rd /s /q msi_checks
        COMMAND mkdir msi_checks
        COMMAND cd msi_checks && ${${PROJECT_NAME}_RUN_SCRIPTING_TASK}
                msi-checks ${${PROJECT_NAME}_DEST_DIR}
        DEPENDS st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Running MSI checks ..." )
