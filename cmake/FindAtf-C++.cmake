find_package(PkgConfig QUIET)
pkg_check_modules(Atf-C++ QUIET IMPORTED_TARGET atf-c++)

find_path(Atf-C++_INCLUDE_DIR atf-c++.hpp
	PATHS
	  "/usr/include"
	  "/usr/local/include"
	  ${Atf-C++_INCLUDEDIR}
	  PATH_SUFFIXES "atf-c++"
	)

find_library(Atf-C++_LIBRARY
	NAMES libatf-c++.so
	PATHS
	  /usr/lib
	  /usr/local/lib
	  ${Atf-C++_LIBDIR}
	)

if (Atf-C++_INCLUDE_DIR AND Atf-C++_LIBRARY)
	set(Atf-C++_FOUND TRUE)
	set(Atf-C++_LIBRARIES ${Atf-C++_LIBRARY})
	set(Atf-C++_INCLUDE_DIRS ${Atf-C++_INCLUDE_DIR})
else (Atf-C++_INCLUDE_DIR AND Atf-C++_LIBRARY)
	set(Atf-C++_FOUND FALSE)
endif (Atf-C++_INCLUDE_DIR AND Atf-C++_LIBRARY)


find_package_handle_standard_args(Atf-C++ DEFAULT_MSG
	Atf-C++_LIBRARIES
	Atf-C++_INCLUDE_DIRS)

if(Atf-C++_FOUND AND NOT TARGET Atf-C++::Atf-C++)
	if (SYSTEM_Atf-C++)
		add_library(Atf-C++::Atf-C++ IMPORTED INTERFACE)
	else()
		add_library(Atf-C++::Atf-C++ UNKNOWN IMPORTED)
		set_property(TARGET Atf-C++::Atf-C++ APPEND PROPERTY
			IMPORTED_LOCATION "${Atf-C++_LIBRARY}")
	endif()

	set_target_properties(Atf-C++::Atf-C++ PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${Atf-C++_INCLUDE_DIRS}")
endif()
