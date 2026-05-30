cmake_minimum_required(VERSION 3.5)

project(BearLibTerminal)

if(NOT CMAKE_SYSTEM_NAME MATCHES "Linux|Windows|Darwin")
    message(FATAL_ERROR "${CMAKE_SYSTEM_NAME} is not supported.")
endif()

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Build type was not specified, switching to 'Release'")
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()

add_subdirectory(./Terminal)

if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/Samples")
    add_subdirectory(./Samples/Omni)
endif()