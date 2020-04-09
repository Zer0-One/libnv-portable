cmake_minimum_required(VERSION 3.14.6)

project(libnv-portable VERSION 1.0.0 DESCRIPTION "A cross-platform userspace version of libnv, ported from FreeBSD")

# Set options
option(NVP_TEST "Enable unit tests" OFF)
option(BUILD_SHARED_LIBS "Build as a shared library" ON)

add_library(nvp
    src/cnvlist.c
    src/dnvlist.c
    src/msgio.c
    src/nvlist.c
    src/nvpair.c
)

target_include_directories(nvp
    PUBLIC include
    PRIVATE src
)

target_compile_features(nvp
    PUBLIC c_std_99
)

set_target_properties(nvp
    PROPERTIES
        VERSION ${PROJECT_VERSION}
        SOVERSION ${PROJECT_VERSION_MAJOR}
        C_STANDARD 99
        C_STANDARD_REQUIRED TRUE
        C_EXTENSIONS OFF
        LIBRARY_OUTPUT_DIRECTORY bin
)

target_compile_definitions(nvp
    PRIVATE
        _DEFAULT_SOURCE
        _XOPEN_SOURCE=600
)

# If we're on Linux, link against libbsd
target_link_libraries(nvp PUBLIC $<$<PLATFORM_ID:Linux>:bsd>)

function(build_test target)
    add_executable(${target} tests/${target}.c)
    target_link_libraries(${target}
        nvp
        $<$<PLATFORM_ID:Linux>:bsd>
    )

    set_target_properties(${target}
        PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY bin/test
    )

    add_test(NAME ${target} COMMAND ${target} WORKING_DIRECTORY bin/test)
    set_tests_properties(${target}
        PROPERTIES
            PASS_REGULAR_EXPRESSION "all ok"
    )
endfunction()

# If tests are enabled, make tests
if(NVP_TEST)
    enable_testing()

    build_test(nvlist_add_test)
    build_test(nvlist_append_test)
    build_test(nvlist_exists_test)
    build_test(nvlist_free_test)
    build_test(nvlist_get_test)
    build_test(nvlist_move_test)
endif()
