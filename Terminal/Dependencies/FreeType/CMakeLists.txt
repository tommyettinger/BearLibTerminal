cmake_minimum_required(VERSION 3.5)

project(freetype2)

set(SOURCES
    ./Source/autofit/autofit.c
    ./Source/base/ftbase.c
    ./Source/base/ftbbox.c
    ./Source/base/ftdebug.c
    ./Source/base/ftfstype.c
    ./Source/base/ftgasp.c
    ./Source/base/ftglyph.c
    ./Source/base/ftinit.c
    ./Source/base/ftlcdfil.c
    ./Source/base/ftmm.c
    ./Source/base/ftsystem.c
    ./Source/raster/raster.c
    ./Source/sfnt/sfnt.c
    ./Source/smooth/smooth.c
    ./Source/truetype/truetype.c)

add_library(freetype2 STATIC ${SOURCES})

target_include_directories(freetype2 PUBLIC ./Include)

target_compile_definitions(freetype2 PRIVATE FT2_BUILD_LIBRARY)

if(UNIX)
    set_target_properties(freetype2 PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()