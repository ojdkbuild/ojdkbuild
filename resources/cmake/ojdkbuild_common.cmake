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

if ( NOT DEFINED OJDKBUILD_COMMON )
    # override some default options
    OPTION ( BUILD_SHARED_LIBS "Build shared libraries" OFF )
    OPTION ( CMAKE_INCLUDE_DIRECTORIES_BEFORE "Prefer local libs over system ones" ON )
    set_property ( GLOBAL PROPERTY USE_FOLDERS ON )

    # output directories
    set ( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )
    set ( CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )
    set ( CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )
    set ( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )
    set ( CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )
    set ( CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )    
    set ( CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )
    set ( CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )
    set ( CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" )    

    # compiler flags
    if ( NOT DEFINED CMAKE_BUILD_TYPE )
        set ( CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type" )
    elseif ( NOT  CMAKE_BUILD_TYPE MATCHES "Release|Debug" )
        message ( FATAL_ERROR "Unsupported build type: [${CMAKE_BUILD_TYPE}]" )
    endif ( )    
    if ( WIN32 )
        set ( CMAKE_C_FLAGS "/EHsc /D _LIB /D _CRT_SECURE_NO_WARNINGS /D WIN32_LEAN_AND_MEAN /D_WIN32_WINNT=0x0601" CACHE INTERNAL "" )
        set ( CMAKE_C_FLAGS_DEBUG "/D _DEBUG /MT /Zi /Ob0 /Od /RTC1" CACHE INTERNAL "" )
        set ( CMAKE_C_FLAGS_RELEASE "/D NDEBUG /MT /Zi /Ox /Gy /GT /GR-" CACHE INTERNAL "" )
        set ( CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE INTERNAL "" )
        set ( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}" CACHE INTERNAL "" )
        set ( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}" CACHE INTERNAL "" )
        set ( CMAKE_EXE_LINKER_FLAGS_DEBUG "/DEBUG /MAP" CACHE INTERNAL "" )
        set ( CMAKE_EXE_LINKER_FLAGS_RELEASE "/DEBUG /OPT:REF /OPT:ICF /MAP" CACHE INTERNAL "" )
        set ( CMAKE_SHARED_LINKER_FLAGS_DEBUG "/DEBUG /MAP" CACHE INTERNAL "" )
        set ( CMAKE_SHARED_LINKER_FLAGS_RELEASE "/DEBUG /OPT:REF /OPT:ICF /MAP" CACHE INTERNAL "" )
    else ( )
        message ( WARNING "Running on non-Windows platform" )
    endif ( )

    # subdirectory macro
    macro ( ojdkbuild_add_subdirectory _project_path )
        string ( REGEX REPLACE "^.*/" "" _target_name ${_project_path} )
        set ( _target_name ojdkbuild_${_target_name} )
        if ( NOT TARGET ${_target_name} )
            message ( STATUS "Adding dependency: [${_target_name}], path: [${_project_path}]" )
            add_subdirectory ( ${_project_path} ${CMAKE_BINARY_DIR}/${_target_name} )
            set_target_properties ( ${_target_name} PROPERTIES FOLDER "deps" )
        endif ( )
    endmacro ( )

    # external macro
    macro ( ojdkbuild_add_external _project_path )
        string ( REGEX REPLACE "^.*/" "" _target_name ${_project_path} )
        set ( _target_name external_${_target_name} )
        if ( NOT TARGET ${_target_name} )
            message ( STATUS "Adding dependency: [${_target_name}], path: [${_project_path}]" )
            add_subdirectory ( ${_project_path} ${CMAKE_BINARY_DIR}/${_target_name} )
            set_target_properties ( ${_target_name} PROPERTIES FOLDER "external" )
        endif ( )
    endmacro ( )

    # pkg-config macro
    macro ( ojdkbuild_pkg_check_modules _out_var_name _modifier _modules_list_var_name )
        find_package ( PkgConfig )
        if ( WIN32 )
            set ( PATHENV_SEPARATOR ";" )
        else ( )
            set ( PATHENV_SEPARATOR ":" )
        endif ( )
        set ( _pkgconfig_path $ENV{PKG_CONFIG_PATH} )
        set ( ENV{PKG_CONFIG_PATH} "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig${PATHENV_SEPARATOR}$ENV{PKG_CONFIG_PATH}" )
        pkg_check_modules ( ${_out_var_name} ${_modifier} ${${_modules_list_var_name}} )
        set ( ENV{PKG_CONFIG_PATH} ${_pkgconfig_path} )
    endmacro ( )

    # tests macro
    macro ( ojdkbuild_enable_testing _includes_var_name _libs_var_name _opts_var_name )
        set ( ${PROJECT_NAME}_CXX_EXTENSION cpp CACHE INTERNAL "" )
        set ( ${PROJECT_NAME}_TEST_POSTFIX _test CACHE INTERNAL "" )
        enable_testing ( )
        file ( GLOB ${PROJECT_NAME}_TEST_SRC
                RELATIVE ${CMAKE_CURRENT_LIST_DIR}
                ${CMAKE_CURRENT_LIST_DIR}/*${${PROJECT_NAME}_TEST_POSTFIX}.${${PROJECT_NAME}_CXX_EXTENSION} )
        foreach ( _testsrc ${${PROJECT_NAME}_TEST_SRC} )
            string ( REPLACE .${${PROJECT_NAME}_CXX_EXTENSION} "" _testname ${_testsrc} )
            message ( STATUS "Adding test: [${_testname}]" )
            add_executable ( ${_testname} ${CMAKE_CURRENT_LIST_DIR}/${_testsrc} )
            target_include_directories ( ${_testname} BEFORE PRIVATE ${${_includes_var_name}} )
            target_link_libraries ( ${_testname} ${${_libs_var_name}} )
            target_compile_options ( ${_testname} PRIVATE ${${_opts_var_name}} )
            set_target_properties ( ${_testname} PROPERTIES FOLDER "test" )
            if ( DEFINED CMAKE_MEMORYCHECK_COMMAND )
                add_test ( ${_testname}
                        ${CMAKE_MEMORYCHECK_COMMAND} ${CMAKE_MEMORYCHECK_COMMAND_OPTIONS}
                        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${_testname} )
            else ( )
                add_test ( ${_testname} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${_testname} )
            endif ( )
        endforeach ( )
    endmacro ( )

    # lookaside dirs
    set ( curl_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/curl CACHE INTERNAL "" )
    set ( freetype_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/freetype CACHE INTERNAL "" )
    set ( gif_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/giflib CACHE INTERNAL "" )
    set ( jansson_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/jansson CACHE INTERNAL "" )
    set ( libjpeg-turbo_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/libjpeg-turbo CACHE INTERNAL "" )
    set ( openssl_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/openssl CACHE INTERNAL "" )
    set ( png_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/libpng CACHE INTERNAL "" )
    set ( popt_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/popt CACHE INTERNAL "" )
    set ( z_LOOKASIDE_DIR ${OJDKBUILD_DIR}/lookaside/zlib CACHE INTERNAL "" )

    # sentinel
    set ( OJDKBUILD_COMMON "ON" )
endif ( )
