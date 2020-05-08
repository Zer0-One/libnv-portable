
cmake_minimum_required(VERSION 3.11)

project(libnv-portable VERSION 1.0.0 DESCRIPTION "A cross-platform userspace version of libnv, ported from FreeBSD")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")

include(GNUInstallDirs)

# Set options
option(NVP_TEST "Enable unit tests" OFF)
option(BUILD_SHARED_LIBS "Build as a shared library" ON)

find_package(Atf-C)
find_package(Atf-C++)
find_program(Kyua kyua)

if(NOT Atf-C_FOUND OR NOT Atf-C++_FOUND OR NOT Kyua)
    message("Will not build ATF tests.")
    set(TEST_ATF FALSE)
else()
    set(TEST_ATF TRUE)
endif()

add_library(nvp
    src/cnvlist.c
    src/dnvlist.c
    src/msgio.c
    src/nvlist.c
    src/nvpair.c
)

set(nvp_includes
    include/cnv.h
    include/dnv.h
    include/nv.h
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
        ARCHIVE_OUTPUT_DIRECTORY bin
        PUBLIC_HEADER "${nvp_includes}"
)

target_compile_definitions(nvp
    PRIVATE
        _DEFAULT_SOURCE
        $<$<PLATFORM_ID:Linux>:_XOPEN_SOURCE=600>
)

# If we're on Linux, link against libbsd
target_link_libraries(nvp PUBLIC $<$<PLATFORM_ID:Linux>:bsd>)

install(
    TARGETS nvp DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

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

function(build_atf_test target atfcpp)
    if(atfcpp)
        add_executable(${target} tests/${target}.cc)
        target_link_libraries(${target}
            Atf-C++::Atf-C++
            nvp
            $<$<PLATFORM_ID:Linux>:bsd>
        )
    else()
        add_executable(${target} tests/${target}.c)
        target_link_libraries(${target}
            Atf-C::Atf-C
            nvp
            $<$<PLATFORM_ID:Linux>:bsd>
        )
    endif()

    set_target_properties(${target}
        PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY bin/test
    )

    add_test(NAME ${target}
        COMMAND
            ${Kyua} test --kyuafile ${CMAKE_CURRENT_SOURCE_DIR}/tests/Kyuafile
                --build-root ${CMAKE_CURRENT_BINARY_DIR}/bin/test ${target}
        WORKING_DIRECTORY
            bin/test
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

    if(TEST_ATF)
        build_atf_test(nvlist_send_recv_test NO)
        build_atf_test(nv_tests YES)
        build_atf_test(cnv_tests YES)
        build_atf_test(dnv_tests YES)
        build_atf_test(nv_array_tests YES)
    endif()
endif()
