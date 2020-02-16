cmake_minimum_required(VERSION 3.14.6)
cmake_policy(VERSION 3.14.6)

project(libnv-portable VERSION 1.0.0 DESCRIPTION "A cross-platform userspace version of libnv, ported from FreeBSD")

# Set output directory
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY bin)

add_library(nvp SHARED)
target_sources(nvp
    PRIVATE
        "src/cnvlist.c"
        "src/dnvlist.c"
        "src/msgio.c"
        "src/nvlist.c"
        "src/nvpair.c"
)

# Set include directories
target_include_directories(nvp PUBLIC include)
target_include_directories(nvp PRIVATE src)

# Set library version
set_target_properties(nvp PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(nvp PROPERTIES SOVERSION ${PROJECT_VERSION_MAJOR})

# Set compiler/language options
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)

# If we're on Linux, link against libbsd
if(CMAKE_SYSTEM_NAME MATCHES ".*Linux")
    target_link_libraries(nvp bsd)
endif()


