find_package(PkgConfig QUIET)
pkg_check_modules(Atf-C QUIET IMPORTED_TARGET atf-c)

find_path(Atf-C_INCLUDE_DIR atf-c.h
	PATHS
	  "/usr/include"
	  "/usr/local/include"
	  ${Atf-C_INCLUDEDIR}
	  PATH_SUFFIXES "atf-c"
	)

find_library(Atf-C_LIBRARY
	NAMES libatf-c.so
	PATHS
	  /usr/lib
	  /usr/local/lib
	  ${Atf-C_LIBDIR}
	)

if (Atf-C_INCLUDE_DIR AND Atf-C_LIBRARY)
	set(Atf-C_FOUND TRUE)
	set(Atf-C_LIBRARIES ${Atf-C_LIBRARY})
	set(Atf-C_INCLUDE_DIRS ${Atf-C_INCLUDE_DIR})
else (Atf-C_INCLUDE_DIR AND Atf-C_LIBRARY)
	set(Atf-C_FOUND FALSE)
endif (Atf-C_INCLUDE_DIR AND Atf-C_LIBRARY)


find_package_handle_standard_args(Atf-C DEFAULT_MSG
	Atf-C_LIBRARIES
	Atf-C_INCLUDE_DIRS)

if(Atf-C_FOUND AND NOT TARGET Atf-C::Atf-C)
	if (SYSTEM_Atf-C)
		add_library(Atf-C::Atf-C IMPORTED INTERFACE)
	else()
		add_library(Atf-C::Atf-C UNKNOWN IMPORTED)
		set_property(TARGET Atf-C::Atf-C APPEND PROPERTY
			IMPORTED_LOCATION "${Atf-C_LIBRARY}")
	endif()

	set_target_properties(Atf-C::Atf-C PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${Atf-C_INCLUDE_DIRS}")
endif()