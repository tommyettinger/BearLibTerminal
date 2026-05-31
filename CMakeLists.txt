cmake_minimum_required(VERSION 3.5)

project(BearLibTerminal)

# Use static CRT on Windows to avoid runtime library mismatch between targets.
# Direct flag approach works regardless of cmake_minimum_required version in subdirectories.
if(MSVC)
	foreach(flag_var
		CMAKE_C_FLAGS_RELEASE CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO
		CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
		if(${flag_var} MATCHES "/MD")
			string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
		endif()
	endforeach()
	foreach(flag_var
		CMAKE_C_FLAGS_DEBUG CMAKE_CXX_FLAGS_DEBUG)
		if(${flag_var} MATCHES "/MDd")
			string(REGEX REPLACE "/MDd" "/MTd" ${flag_var} "${${flag_var}}")
		endif()
	endforeach()
endif()

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