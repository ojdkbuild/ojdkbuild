
cmake_minimum_required ( VERSION 2.8.12 )

# project
set ( OJDKBUILD_DIR ${CMAKE_CURRENT_LIST_DIR}/../.. CACHE INTERNAL "" )
include ( ${OJDKBUILD_DIR}/resources/cmake/ojdkbuild_common.cmake )
project ( openjdk NONE )

# options
set ( ${PROJECT_NAME}_MILESTONE "ojdkbuild" CACHE STRING "Version string 'milestone' field" )
set ( ${PROJECT_NAME}_UPDATE "77" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_BUILD "03" CACHE STRING "Version string 'build' field" )
set ( ${PROJECT_NAME}_RPMBUILD "0" CACHE STRING "Build number in image name" )
set ( ${PROJECT_NAME}_UNLIMITED_CRYPTO_FLAG "yes" CACHE STRING "Whether to enable unlimited cryptography" )
set ( ${PROJECT_NAME}_DEBUG_SYMBOLS_FLAG "no" CACHE STRING "Whether to generate debug symbols" )
set ( ${PROJECT_NAME}_DEBUG_LEVEL "release" CACHE STRING "Debug level for native compilation" )
set ( ${PROJECT_NAME}_LOG_LEVEL "info" CACHE STRING "Logging verbosity during the build" )
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "6" CACHE STRING "ZIP compress level" )

# dev options
set ( ${PROJECT_NAME}_DEV_MODE OFF CACHE BOOL 
        "Whether to invoke 'bash' and give CLI to the developer instead of running configure and make in 'openjdk' target" )

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
        
# shorcut vars
set ( ${PROJECT_NAME}_IMAGE java-1.8.0-openjdk-1.8.0.${${PROJECT_NAME}_UPDATE}-${${PROJECT_NAME}_RPMBUILD}.b${${PROJECT_NAME}_BUILD}.windows.x86_64 )        
set ( ${PROJECT_NAME}_TZDATA_SRC ${OJDKBUILD_DIR}/lookaside/tzdata )
set ( ${PROJECT_NAME}_TZDATA_DEST ${OJDKBUILD_DIR}/lookaside/java-1.8.0-openjdk/jdk/make/data/tzdata )
set ( ${PROJECT_NAME}_FONTS_SRC ${CMAKE_CURRENT_LIST_DIR}/../../resources/fonts )
set ( ${PROJECT_NAME}_FONTS_DEST ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/jre/lib/fonts )        
        
# target
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
                ${CMAKE_CURRENT_LIST_DIR}/../../lookaside/java-1.8.0-openjdk/build/windows-x86_64-normal-server-release/images/j2sdk-image
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}
        # remove demo and sample
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}/demo
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${${PROJECT_NAME}_IMAGE}/sample
        # add fonts
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${${PROJECT_NAME}_FONTS_SRC}/ttf ${${PROJECT_NAME}_FONTS_DEST}
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_FONTS_SRC}/LICENSE ${${PROJECT_NAME}_FONTS_DEST}
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_FONTS_SRC}/AUTHORS ${${PROJECT_NAME}_FONTS_DEST}
        COMMAND ${CMAKE_COMMAND} -E copy ${${PROJECT_NAME}_FONTS_SRC}/README ${${PROJECT_NAME}_FONTS_DEST}
        # bundle image
        COMMAND ${CMAKE_CURRENT_LIST_DIR}/../../tools/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Starting OpenJDK build ..." )       
add_dependencies ( ${PROJECT_NAME} ojdkbuild_freetype ojdkbuild_zlib ojdkbuild_nss )

