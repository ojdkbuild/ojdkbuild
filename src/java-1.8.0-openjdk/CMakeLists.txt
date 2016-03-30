
cmake_minimum_required ( VERSION 2.8.12 )

# project
include ( ${CMAKE_CURRENT_LIST_DIR}/../../resources/cmake/ojdkbuild_common.cmake )
project ( openjdk NONE )

# options
set ( ${PROJECT_NAME}_MILESTONE "ojdkbuild" CACHE STRING "Version string 'milestone' field" )
set ( ${PROJECT_NAME}_UPDATE "71" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_BUILD "15" CACHE STRING "Version string 'build' field" )
set ( ${PROJECT_NAME}_UNLIMITED_CRYPTO_FLAG "yes" CACHE STRING "Whether to enable unlimited cryptography" )
set ( ${PROJECT_NAME}_DEBUG_SYMBOLS_FLAG "no" CACHE STRING "Whether to generate debug symbols" )
set ( ${PROJECT_NAME}_DEBUG_LEVEL "release" CACHE STRING "Debug level for native compilation" )
set ( ${PROJECT_NAME}_LOG_LEVEL "info" CACHE STRING "Logging verbosity during the build" )
set ( ${PROJECT_NAME}_COMPRESS_LEVEL "6" CACHE STRING "ZIP compress level" )

# dependencies
#ojdkbuild_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/../zlib )
ojdkbuild_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/../../deps/freetype )
#ojdkbuild_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/../nss )

# resources
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/configure-and-make.bat
        ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.bat 
        NEWLINE_STYLE WIN32 )
configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/configure-and-make.sh
        ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.sh
        NEWLINE_STYLE UNIX )
        
set ( ${PROJECT_NAME}_IMAGE java-1.8.0-openjdk-1.8.0.${${PROJECT_NAME}_UPDATE}-0.b${${PROJECT_NAME}_BUILD}.windows.x86_64 )        
        
# target
add_custom_target ( ${PROJECT_NAME}
        # freetype
#        COMMAND ${CMAKE_COMMAND} -E copy
#            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/ojdkbuild_freetype.dll
#            ${CMAKE_CURRENT_BINARY_DIR}/freetype/freetype.dll
#        COMMAND ${CMAKE_COMMAND} -E copy
#            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/ojdkbuild_freetype.lib
#            ${CMAKE_CURRENT_BINARY_DIR}/freetype/freetype.lib
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
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                ${CMAKE_CURRENT_LIST_DIR}/../../resources/fonts/ttf
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/jre/lib/fonts
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/../../resources/fonts/LICENSE
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/jre/lib/fonts
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/../../resources/fonts/AUTHORS
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/jre/lib/fonts
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/../../resources/fonts/README
                ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_IMAGE}/jre/lib/fonts
        # bundle image
        COMMAND ${CMAKE_CURRENT_LIST_DIR}/../../tools/zip/zip.exe -qr${${PROJECT_NAME}_COMPRESS_LEVEL} ${${PROJECT_NAME}_IMAGE}.zip ${${PROJECT_NAME}_IMAGE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Starting OpenJDK build ..." )       
add_dependencies ( ${PROJECT_NAME} ojdkbuild_freetype )

