
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
    set ( CMAKE_BUILD_TYPE "Release" CACHE STRING "Default build type" )    
    if ( WIN32 )
        set ( CMAKE_C_FLAGS "/EHsc /D _LIB /D _CRT_SECURE_NO_WARNINGS /D WIN32_LEAN_AND_MEAN" CACHE INTERNAL "" )
        set ( CMAKE_C_FLAGS_DEBUG "/D _DEBUG /MTd /Zi /Ob0 /Od /RTC1" CACHE INTERNAL "" )
        set ( CMAKE_C_FLAGS_RELEASE "/D NDEBUG /MT /Ox /Gy /GT /GR-" CACHE INTERNAL "" )
        set ( CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE INTERNAL "" )
        set ( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}" CACHE INTERNAL "" )
        set ( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}" CACHE INTERNAL "" )
    elseif ( APPLE )
        message ( FATAL_ERROR "Mac OS X support is not implemented yet" )    
    elseif ( UNIX )
        message ( FATAL_ERROR "Linux support is not implemented yet" )
    else ()
        message ( FATAL_ERROR "Unsupported platform" )
    endif ( )
    
    # subdirecroty macro
    macro ( ojdkbuild_add_subdirectory _project_path )
        string ( REGEX REPLACE "^.*/" "" _target_name ${_project_path} )
        set ( _target_name ojdkbuild_${_target_name} )
        if ( NOT TARGET ${_target_name} )
            message ( STATUS "Adding dependency: [${_target_name}], path: [${_project_path}]" )
            add_subdirectory ( ${_project_path} ${CMAKE_BINARY_DIR}/${_target_name} )
            set_target_properties ( ${_target_name} PROPERTIES FOLDER "deps" )
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

    # sentinel
    set ( OJDKBUILD_COMMON "ON" )
endif ( )
