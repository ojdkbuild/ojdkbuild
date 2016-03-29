
cmake_minimum_required ( VERSION 2.8.12 )

# project
include ( ${CMAKE_CURRENT_LIST_DIR}/../../resources/cmake/ojdkbuild_common.cmake )
project ( openjdk NONE )

# options
set ( ${PROJECT_NAME}_MILESTONE "ojdkbuild" CACHE STRING "Version string 'milestone' field" )
set ( ${PROJECT_NAME}_UPDATE "71" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_BUILD "15" CACHE STRING "Version string 'build' field" )

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
        
# target
add_custom_target ( ${PROJECT_NAME}
#        COMMAND ${CMAKE_COMMAND} -E copy
#            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/ojdkbuild_freetype.dll
#            ${CMAKE_CURRENT_BINARY_DIR}/freetype/freetype.dll
#        COMMAND ${CMAKE_COMMAND} -E copy
#            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/ojdkbuild_freetype.lib
#            ${CMAKE_CURRENT_BINARY_DIR}/freetype/freetype.lib
        COMMAND cmd.exe /c ${CMAKE_CURRENT_BINARY_DIR}/configure-and-make.bat
        COMMENT "Starting OpenJDK build ..." )       
add_dependencies ( ${PROJECT_NAME} ojdkbuild_freetype )

