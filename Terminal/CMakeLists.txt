cmake_minimum_required(VERSION 3.5)

project(BearLibTerminal)

if(UNIX AND NOT APPLE)
    set(LINUX TRUE)
endif()

option(BUILD_SHARED_LIBS "Build dynamic version of library" ON)

add_subdirectory(Dependencies/FreeType)
add_subdirectory(Dependencies/PicoPNG)

if(EXISTS "../CHANGELOG.md")
    file(STRINGS "../CHANGELOG.md" TERMINAL_VERSION_TOP_LINE LIMIT_COUNT 1)
    string(REGEX MATCH "[0-9\\.]+" TERMINAL_VERSION ${TERMINAL_VERSION_TOP_LINE})
else()
    set(TERMINAL_VERSION "Unknown")
endif()

# Detect system bitness
math(EXPR BITNESS "8*${CMAKE_SIZEOF_VOID_P}")

file(GLOB TERMINAL_HEADERS ./Source/*.hpp ./Source/*.h)
list(APPEND TERMINAL_HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/Include/C/BearLibTerminal.h")
if(APPLE)
    file(GLOB TERMINAL_SOURCES ./Source/*.cpp ./Source/*.mm)
else()
    file(GLOB TERMINAL_SOURCES ./Source/*.cpp)
endif()

# Flagi kompilatora — zastąpiono -std=c++0x nowoczesnym odpowiednikiem
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Release flags
if(MSVC)
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT /O2 /DNDEBUG")
else()
	set(CMAKE_CXX_FLAGS_RELEASE "-O2 -g0")
	if(NOT APPLE)
		set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "-s")
	endif()
endif()

# Debug flags
if(MSVC)
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd /Od /Zi /RTC1")
else()
	set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g3")
endif()

# Common flags
if(NOT MSVC)
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fvisibility=hidden")
endif()
if(WIN32)
	add_compile_definitions(UNICODE)
	if(NOT MSVC)
		set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -static")
	endif()
elseif(LINUX)
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -static-libgcc")
endif()
if(NOT BUILD_SHARED_LIBS)
    add_compile_definitions(BEARLIBTERMINAL_STATIC_BUILD)
endif()

find_package(OpenGL REQUIRED)
if(APPLE)
    find_library(COCOA_LIBRARY Cocoa REQUIRED)
endif()

include_directories(./Include/C)
include_directories(./Dependencies/FreeType/Include)
include_directories(./Dependencies/PicoPNG/Include)
include_directories(./Dependencies/NanoJPEG/Include)

add_library(BearLibTerminal ${TERMINAL_SOURCES} ${TERMINAL_HEADERS})

target_compile_definitions(BearLibTerminal PRIVATE TERMINAL_VERSION="${TERMINAL_VERSION}")

target_link_libraries(BearLibTerminal PRIVATE freetype2)
target_link_libraries(BearLibTerminal PRIVATE picopng)
target_link_libraries(BearLibTerminal PRIVATE OpenGL::GL)
if(WIN32)
    target_link_libraries(BearLibTerminal PRIVATE winmm.lib)
    target_link_libraries(BearLibTerminal PRIVATE
        ${PROJECT_SOURCE_DIR}/Resource/Terminal-${BITNESS}bit.res)
elseif(LINUX)
    target_link_libraries(BearLibTerminal PRIVATE pthread)
elseif(APPLE)
    target_link_libraries(BearLibTerminal PRIVATE ${COCOA_LIBRARY})
endif()

set(OUTPUT_DIR ${CMAKE_SOURCE_DIR}/Output/${CMAKE_SYSTEM_NAME}${BITNESS})
set_target_properties(BearLibTerminal PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIR})

if(WIN32)
    set_target_properties(BearLibTerminal PROPERTIES
        PREFIX ""
        SUFFIX ".dll"
        IMPORT_PREFIX ""
        IMPORT_SUFFIX ".lib")
elseif(APPLE)
    set_target_properties(BearLibTerminal PROPERTIES
        BUILD_WITH_INSTALL_RPATH TRUE
        INSTALL_NAME_DIR "@executable_path")
endif()