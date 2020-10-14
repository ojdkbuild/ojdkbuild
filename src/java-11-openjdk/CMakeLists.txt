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

# version
set ( ${PROJECT_NAME}_MAJOR_VERSION "11" CACHE STRING "Major version number" )
set ( ${PROJECT_NAME}_UPDATE "9" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_BUILD "4" CACHE STRING "Version string 'build' field" )
set ( ${PROJECT_NAME}_RPMBUILD "0" CACHE STRING "Build number in image name" )

# options
set ( ${PROJECT_NAME}_DEST_DIR ${OJDKBUILD_DIR}/dist CACHE STRING "Destination directory" )
set ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE OFF CACHE BOOL "Enable bootcycle build" )
set ( ${PROJECT_NAME}_ENABLE_JMC ON CACHE BOOL "Enable JDK Mission Control build" )
set ( ${PROJECT_NAME}_ENABLE_CLEANUP OFF CACHE BOOL "Delete temporary build files before creating the installer" )
set ( ${PROJECT_NAME}_ENABLE_EA ON CACHE BOOL "Add 'Early Access' label to version string and artifact names" )
# zip bundle options
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "9" CACHE STRING "ZIP compress level" )
# vendor options
set ( ${PROJECT_NAME}_VENDOR_NAME "ojdkbuild" CACHE STRING "Value for 'java.vendor' property" )
set ( ${PROJECT_NAME}_VENDOR_URL "https://github.com/ojdkbuild" CACHE STRING "Value for 'java.vendor.url' property" )
set ( ${PROJECT_NAME}_VENDOR_BUG_URL "https://github.com/ojdkbuild/ojdkbuild/issues" CACHE STRING "Value for 'java.vendor.url.bug' property" )
# installer options
set ( ${PROJECT_NAME}_INSTALLER_HELP_LINK "https://github.com/ojdkbuild" CACHE STRING "Installer help link" )
set ( ${PROJECT_NAME}_INSTALLER_UPDATE_UUID "f44d92b6-bfab-41ca-85a1-428e4dc741d2" CACHE STRING "Installer update UUID" )
set ( ${PROJECT_NAME}_INSTALLER_JRE_UPDATE_UUID "ac57b14a-139c-4854-aa3e-d39623ec45f5" CACHE STRING "JRE Installer update UUID" )
set ( ${PROJECT_NAME}_INSTALLER_RESOURCES_PATH "${OJDKBUILD_DIR}/resources/installer/instres" CACHE STRING "Path to installer resources" )
set ( ${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS "" CACHE STRING "Additional options to pass to installer's linker" )
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
# bootcycle vars
if ( ${PROJECT_NAME}_ENABLE_BOOTCYCLE )
    set ( ${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/bootcycle-build/images" CACHE INTERNAL "" )
else ( )
    set ( ${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/images" CACHE INTERNAL "" )
endif ( )
# boot jdk path
set ( ${PROJECT_NAME}_BOOT_JDK "${OJDKBUILD_DIR}/tools/bootjdk10" CACHE INTERNAL "" )
# EA options
if ( ${PROJECT_NAME}_ENABLE_EA )
    set ( ${PROJECT_NAME}_EA_LABEL ".ea" CACHE INTERNAL "" )
    set ( ${PROJECT_NAME}_EA_DESIGNATOR "ea" CACHE INTERNAL "" )
endif ( )

# image naming
set ( ${PROJECT_NAME}_EXE_VERSION "${${PROJECT_NAME}_MAJOR_VERSION},${${PROJECT_NAME}_UPDATE},${${PROJECT_NAME}_BUILD},${${PROJECT_NAME}_RPMBUILD}" CACHE INTERNAL "EXE version field" )
set ( ${PROJECT_NAME}_FILE_VERSION "${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}.${${PROJECT_NAME}_BUILD}.${${PROJECT_NAME}_RPMBUILD}" CACHE INTERNAL "File version field" )
set ( ${PROJECT_NAME}_BASE_PREFIX java-${${PROJECT_NAME}_MAJOR_VERSION}-openjdk${${PROJECT_NAME}_DEBUG_IMAGE_LABEL} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE_POSTFIX_NVR ${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}.${${PROJECT_NAME}_BUILD}-${${PROJECT_NAME}_RPMBUILD}${${PROJECT_NAME}_EA_LABEL} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE_POSTFIX ${${PROJECT_NAME}_BASE_POSTFIX_NVR}.windows.${${PROJECT_NAME}_VENDOR_LOWERCASE} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_BASE ${${PROJECT_NAME}_BASE_PREFIX}-${${PROJECT_NAME}_BASE_POSTFIX} CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_IMAGE ${${PROJECT_NAME}_BASE}.x86_64 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_JRE_IMAGE ${${PROJECT_NAME}_BASE_PREFIX}-jre-${${PROJECT_NAME}_BASE_POSTFIX}.x86_64 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_SRCBUNDLE ${${PROJECT_NAME}_BASE_PREFIX}-${${PROJECT_NAME}_BASE_POSTFIX_NVR}.src CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_DEBUGBUNDLE ${${PROJECT_NAME}_IMAGE}.debuginfo CACHE INTERNAL "" )

# copy and other helpers
set ( ${PROJECT_NAME}_RBCFLAGS /ndl /njh /njs /nc /ns /np CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RBCPOSTFIX ^& if errorlevel 1 if not errorlevel 2 exit 0 CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_WIXGEN_JVM_OPTS -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Dcom.sun.xml.bind.v2.bytecode.ClassTailor.noOptimize=true CACHE INTERNAL "" )
set ( ${PROJECT_NAME}_RUN_SCRIPTING_TASK cmd /c ${CMAKE_CURRENT_BINARY_DIR}/st_env.bat ${OJDKBUILD_DIR}/contrib/scripting-tasks/bin/rhino.bat CACHE INTERNAL "" )

# dependencies
# scripting-tasks rhino
add_subdirectory ( ${OJDKBUILD_DIR}/deps/rhino/scripting_tasks ${CMAKE_CURRENT_BINARY_DIR}/st_rhino )
# native
set ( STATICLIB_TOOLCHAIN windows_amd64_msvc CACHE INTERNAL "" )
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
# JDK Mission Control
if ( ${PROJECT_NAME}_ENABLE_JMC )
    if ( NOT DEFINED jmc_JAVA_HOME )
        set ( jmc_JAVA_HOME ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE} CACHE STRING "Path to jdk to use for building JMC" )
    endif ( )
    ojdkbuild_add_subdirectory ( ${OJDKBUILD_DIR}/deps/jmc jmc )
endif ( )

# resources
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/env.bat
        ${CMAKE_CURRENT_BINARY_DIR}/env.bat )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/st_env.bat
        ${CMAKE_CURRENT_BINARY_DIR}/st_env.bat )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/installer.json
        ${CMAKE_CURRENT_BINARY_DIR}/installer.json )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/installer_jre.json
        ${CMAKE_CURRENT_BINARY_DIR}/installer_jre.json )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/jdk_registry_env.xsl
        ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl )
configure_file ( ${OJDKBUILD_DIR}/resources/changelog/NEWS-11.txt
        ${CMAKE_CURRENT_BINARY_DIR}/NEWS
        NEWLINE_STYLE CRLF )

# targets

add_custom_command ( OUTPUT modules
        COMMAND if not exist modules ${OJDKBUILD_DIR}/tools/zip/unzip.exe -qo modules.zip
        WORKING_DIRECTORY ${${PROJECT_NAME}_BOOT_JDK}/lib
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
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${OJDKBUILD_DIR}/lookaside/java-11-openjdk/src/java.desktop/windows/classes/com/sun/java/swing/plaf/windows/icons
                JavaCup32.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${OJDKBUILD_DIR}/lookaside/java-11-openjdk/src/java.desktop/share/classes/javax/swing/plaf/basic/icons
                JavaCup16.png ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Copying icons ..." )

add_custom_command ( OUTPUT ${${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH}/jdk/bin/java.exe
        COMMAND if not exist spec.gmk
                cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash ${OJDKBUILD_DIR}/lookaside/java-11-openjdk/configure
                --disable-hotspot-gtest
                --disable-warnings-as-errors
                --enable-unlimited-crypto=yes
                --with-boot-jdk=${${PROJECT_NAME}_BOOT_JDK}
                --with-cacerts-file=${OJDKBUILD_DIR}/lookaside/ca-certificates/cacerts
                --with-ucrt-dll-dir=${OJDKBUILD_DIR}/tools/toolchain/sdk10_17763/Redist/10.0.17763.0/ucrt/DLLs/x64
                --with-debug-level=${${PROJECT_NAME}_DEBUG_LEVEL}
                --with-log=info
                --with-native-debug-symbols=external
                --with-jvm-features=shenandoahgc
                --with-version-build=${${PROJECT_NAME}_BUILD}
                --with-version-pre=${${PROJECT_NAME}_EA_DESIGNATOR}
                --with-version-opt=LTS
                --with-vendor-version-string=18.9
                --with-vendor-name="${${PROJECT_NAME}_VENDOR_NAME}"
                --with-vendor-url=${${PROJECT_NAME}_VENDOR_URL}
                --with-vendor-bug-url=${${PROJECT_NAME}_VENDOR_BUG_URL}
                --with-vendor-vm-bug-url=${${PROJECT_NAME}_VENDOR_BUG_URL}
                --with-jtreg=${OJDKBUILD_DIR}/tools/jtreg42_653
                --with-num-cores=4
        COMMAND cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat
                bash -c "make ${${PROJECT_NAME}_IMAGES_TARGET} JAVAC_FLAGS=-g"
        DEPENDS bootjdk
                builddir
                cygwin
                ojdkbuild_freetype
                external_zlib
                external_giflib
                external_libjpeg-turbo
                external_libpng
                icons
                tzdata
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
        COMMENT "Building OpenJDK ..." )
add_custom_target ( ${PROJECT_NAME} DEPENDS ${${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH}/jdk/bin/java.exe )

add_custom_target ( preimage
        # copy image
        COMMAND if exist ${${PROJECT_NAME}_IMAGE} rd /s /q ${${PROJECT_NAME}_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH}/jdk ${${PROJECT_NAME}_IMAGE} /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        # remove demo
        COMMAND cd ${${PROJECT_NAME}_IMAGE} && rd /s /q demo
        # copy jre
        COMMAND if exist ${${PROJECT_NAME}_JRE_IMAGE} rd /s /q ${${PROJECT_NAME}_JRE_IMAGE}
        COMMAND (robocopy ${${PROJECT_NAME}_BOOTCYCLE_IMAGES_PATH}/jre ${${PROJECT_NAME}_JRE_IMAGE} /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE} NEWS ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
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
        COMMAND if exist diz_java_exe rd /s /q diz_java_exe
        COMMAND (robocopy openjdk/jdk/bin diz_java_exe java.map /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy openjdk/jdk/bin diz_java_exe java.pdb /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd diz_java_exe && rename java.map java_EXE.map
        COMMAND cd diz_java_exe && rename java.pdb java_EXE.pdb
        COMMAND (robocopy diz_java_exe ${${PROJECT_NAME}_DEBUGBUNDLE} java_EXE.map /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy diz_java_exe ${${PROJECT_NAME}_DEBUGBUNDLE} java_EXE.pdb /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND rd /s /q diz_java_exe
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating release image ..." )

if ( ${PROJECT_NAME}_ENABLE_CLEANUP )
    add_dependencies ( image preimage_cleanup )
else ( )
    add_dependencies ( image preimage )
endif ( )

add_custom_target ( image_jmc
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

add_custom_target ( installer_bundle_contents
        COMMAND if exist ${${PROJECT_NAME}_IMAGE}.installer_bundle rd /s /q ${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE} ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_JRE_IMAGE} ${${PROJECT_NAME}_IMAGE}.installer_bundle/jre /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_IMAGE}.installer_bundle/jdk/missioncontrol ${${PROJECT_NAME}_IMAGE}.installer_bundle/missioncontrol  /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND cd ${${PROJECT_NAME}_IMAGE}.installer_bundle && cd jdk && rd /s /q missioncontrol
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_IMAGE}.installer_bundle/resources /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS zip
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing MSI installer bundle ..." )

add_custom_target ( installer_bundle
        # jdk_base
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                jdk
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer.json
                -o jdk_base.wxs
        # jdk_registry
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                jdk_base.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl
                -o jdk_registry.wxs
        # jdk_jmc
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                missioncontrol
                -c ${CMAKE_CURRENT_BINARY_DIR}/jmc/installer.json
                -o jmc_root.wxs
                -d jmc_directory.xml
                -f jmc_feature.xml
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/jmc/installer.xsl jmc_installer.xsl
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                jdk_registry.wxs
                -x jmc_installer.xsl
                -o jdk_jmc_base.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                jdk_jmc_base.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jmc/installer_env.xsl
                -o ${${PROJECT_NAME}_IMAGE}.wxs
        # jre
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                jre
                -c ${CMAKE_CURRENT_BINARY_DIR}/installer_jre.json
                -o jre_base.wxs
        COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/bin/java.exe ${${PROJECT_NAME}_WIXGEN_JVM_OPTS}
                -jar ${OJDKBUILD_DIR}/tools/wixgen/wixgen.jar
                jre_base.wxs
                -x ${CMAKE_CURRENT_BINARY_DIR}/jdk_registry_env.xsl
                -o ${${PROJECT_NAME}_JRE_IMAGE}.wxs
        # bundle
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.installer_bundle.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle.zip
        DEPENDS installer_bundle_contents
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}.installer_bundle
        COMMENT "Creating MSI installer bundle ..." )

add_custom_target ( installer
        COMMAND if exist i rd /s /q i
        COMMAND rename ${${PROJECT_NAME}_IMAGE}.installer_bundle i
        COMMAND cd i && ${OJDKBUILD_DIR}/tools/wix/bin/candle -v -nologo ${${PROJECT_NAME}_IMAGE}.wxs
        COMMAND cd i && ${OJDKBUILD_DIR}/tools/wix/bin/light
                -nologo -sw1076 -ext WixUIExtension -ext WixUtilExtension
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_IMAGE}.wixobj
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/i ${${PROJECT_NAME}_DEST_DIR}
                ${${PROJECT_NAME}_IMAGE}.msi /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.msi
        # jre
        COMMAND cd i && ${OJDKBUILD_DIR}/tools/wix/bin/candle -v -nologo ${${PROJECT_NAME}_JRE_IMAGE}.wxs
        COMMAND cd i && ${OJDKBUILD_DIR}/tools/wix/bin/light
                -nologo -sw1076 -ext WixUIExtension -ext WixUtilExtension
                ${${PROJECT_NAME}_INSTALLER_LINKER_OPTIONS}
                ${${PROJECT_NAME}_JRE_IMAGE}.wixobj
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/i ${${PROJECT_NAME}_DEST_DIR}
                ${${PROJECT_NAME}_JRE_IMAGE}.msi /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_JRE_IMAGE}.msi
        DEPENDS installer_bundle
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating MSI installer ..." )

add_custom_target ( srcbundle
        COMMAND if exist ${${PROJECT_NAME}_SRCBUNDLE} rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND mkdir ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND cd ${${PROJECT_NAME}_SRCBUNDLE} && mkdir windows
        COMMAND $ENV{GIT_HOME}/bin/git -C ${OJDKBUILD_DIR}/lookaside/java-11-openjdk format-patch origin/lookaside -o ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_SRCBUNDLE}/windows/patches
        COMMAND (robocopy ${OJDKBUILD_DIR}/contrib/local-cleaner ${${PROJECT_NAME}_SRCBUNDLE}/windows/contrib/local-cleaner /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/contrib/ojdkbuild-utils ${${PROJECT_NAME}_SRCBUNDLE}/windows/contrib/ojdkbuild-utils /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/freetype ${${PROJECT_NAME}_SRCBUNDLE}/windows/deps/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/deps/jmc ${${PROJECT_NAME}_SRCBUNDLE}/windows/deps/jmc /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/freetype ${${PROJECT_NAME}_SRCBUNDLE}/windows/external/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/giflib ${${PROJECT_NAME}_SRCBUNDLE}/windows/external/giflib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/windows/external/libjpeg-turbo /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/libpng ${${PROJECT_NAME}_SRCBUNDLE}/windows/external/libpng /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/popt ${${PROJECT_NAME}_SRCBUNDLE}/windows/external/popt /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/external/zlib ${${PROJECT_NAME}_SRCBUNDLE}/windows/external/zlib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/ca-certificates ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/ca-certificates /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/freetype ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/freetype /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/giflib ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/giflib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/libjpeg-turbo ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/libjpeg-turbo /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/libpng ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/libpng /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/popt ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/popt /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/tzdata /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/lookaside/zlib ${${PROJECT_NAME}_SRCBUNDLE}/windows/lookaside/zlib /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/buildres ${${PROJECT_NAME}_SRCBUNDLE}/windows/resources/buildres /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/cmake ${${PROJECT_NAME}_SRCBUNDLE}/windows/resources/cmake /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/resources/tzdata ${${PROJECT_NAME}_SRCBUNDLE}/windows/resources/tzdata /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/src/java-11-openjdk ${${PROJECT_NAME}_SRCBUNDLE}/windows/src/java-11-openjdk /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR}/upstream/jmc ${${PROJECT_NAME}_SRCBUNDLE}/windows/upstream/jmc /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${${PROJECT_NAME}_INSTALLER_RESOURCES_PATH} ${${PROJECT_NAME}_SRCBUNDLE}/windows/resources/installer/instres /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND (robocopy ${OJDKBUILD_DIR} ${${PROJECT_NAME}_SRCBUNDLE} LICENSE /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${${PROJECT_NAME}_SRCBUNDLE} ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND rd /s /q ${${PROJECT_NAME}_SRCBUNDLE}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_SRCBUNDLE}.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS bootjdk st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating sources bundle ..." )

add_custom_target ( test_image
        COMMAND if exist ${${PROJECT_NAME}_IMAGE}.test rd /s /q ${${PROJECT_NAME}_IMAGE}.test
        COMMAND cd ${PROJECT_NAME} && cmd /c ${CMAKE_CURRENT_BINARY_DIR}/env.bat bash -c "make test-image"
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/images/test ${${PROJECT_NAME}_IMAGE}.test /e /nfl ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} zip-dir ${${PROJECT_NAME}_IMAGE}.test ${${PROJECT_NAME}_COMPRESS_LEVEL}
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR} ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.test.zip /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        COMMAND ${${PROJECT_NAME}_RUN_SCRIPTING_TASK} sha256-file ${${PROJECT_NAME}_DEST_DIR}/${${PROJECT_NAME}_IMAGE}.test.zip
        DEPENDS bootjdk st_rhino
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
        DEPENDS bootjdk st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Running MSI checks ..." )

add_custom_target ( jcstress_run
        COMMAND if exist jcstress rd /s /q jcstress
        COMMAND mkdir jcstress
        COMMAND cd jcstress && ${${PROJECT_NAME}_RUN_SCRIPTING_TASK}
                jcstress-run
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}
                ${OJDKBUILD_DIR}/tools/jcstress/jcstress.jar
                ${${PROJECT_NAME}_IMAGE}.jcstress.txt
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/jcstress ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.jcstress.txt /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS bootjdk st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Running jcstress test suite ..." )

add_custom_target ( specjvm_run
        COMMAND if exist specjvm rd /s /q specjvm
        COMMAND mkdir specjvm
        COMMAND cd specjvm && ${${PROJECT_NAME}_RUN_SCRIPTING_TASK}
                specjvm-run
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}
                $ENV{SPECJVM_HOME}/jmh-specjvm2016.jar
                ${${PROJECT_NAME}_IMAGE}.specjvm.txt
        COMMAND (robocopy ${CMAKE_CURRENT_BINARY_DIR}/specjvm ${${PROJECT_NAME}_DEST_DIR} ${${PROJECT_NAME}_IMAGE}.specjvm.txt /mov ${${PROJECT_NAME}_RBCFLAGS} ) ${${PROJECT_NAME}_RBCPOSTFIX}
        DEPENDS bootjdk st_rhino
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Running specjvm test suite ..." )
