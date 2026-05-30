cmake_minimum_required(VERSION 3.5)

project(picopng)

set(SOURCES ./Source/PicoPNG.cpp)

add_library(picopng STATIC ${SOURCES})

target_include_directories(picopng PUBLIC ./Include)

if(UNIX)
    set_target_properties(picopng PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()