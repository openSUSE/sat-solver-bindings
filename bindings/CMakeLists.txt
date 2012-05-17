#
# CMakeLists.txt for bindings
#

ENABLE_TESTING()

MESSAGE(STATUS "Found SWIG version ${SWIG_VERSION}")

#
# Generic setting for all generated bindings
#
SET( SWIG_INPUT "${CMAKE_CURRENT_SOURCE_DIR}/satsolver.i" )


FIND_PACKAGE(Ruby)
FIND_PACKAGE(PythonLibs)

# doesn't work yet :-(
# CMake problem, FindPerlLibs.cmake is in a _really_ bad, bad state :-((
# see e.g. http://www.vtk.org/Bug/print_bug_page.php?bug_id=3665
#FIND_PACKAGE(PerlLibs)
FIND_PACKAGE(Perl)

IF (RUBY_LIBRARY AND RUBY_INCLUDE_PATH)
    ADD_SUBDIRECTORY(ruby)
ELSE (RUBY_LIBRARY AND RUBY_INCLUDE_PATH)
  MESSAGE(WARNING "Skipping Ruby; RUBY_LIBRARY (${RUBY_LIBRARY}) or RUBY_INCLUDE_PATH (${RUBY_INCLUDE_PATH}) not set.")
ENDIF(RUBY_LIBRARY AND RUBY_INCLUDE_PATH)

IF (PYTHON_LIBRARY)
  ADD_SUBDIRECTORY(python)
ELSE(PYTHON_LIBRARY)
  MESSAGE(WARNING "Skipping Python; PYTHON_LIBRARY not set.")
ENDIF(PYTHON_LIBRARY)

IF (PERL_EXECUTABLE)
  ADD_SUBDIRECTORY(perl)
ELSE (PERL_EXECUTABLE)
  MESSAGE(WARNING "Skipping Perl; PERL_EXECUTABLE not set.")
ENDIF (PERL_EXECUTABLE)

SET(bindings_devel_dir "${CMAKE_CURRENT_BINARY_DIR}/satsolver-bindings")
ADD_CUSTOM_COMMAND (
   OUTPUT ${bindings_devel_dir}
   COMMAND ${CMAKE_COMMAND} -E remove_directory ${bindings_devel_dir}
   COMMAND ${CMAKE_COMMAND} -E make_directory "${bindings_devel_dir}"
   # cmake -E copy cannot handle wildcard, so use plain /bin/cp
   COMMAND cp "${CMAKE_SOURCE_DIR}/bindings/*.i" "${bindings_devel_dir}"
   COMMAND cp "${CMAKE_SOURCE_DIR}/bindings/*.h" "${bindings_devel_dir}"
   WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/bindings
   DEPENDS ${CMAKE_SOURCE_DIR}/bindings/*.i
)
ADD_CUSTOM_TARGET(bindings_devel ALL DEPENDS "${bindings_devel_dir}")

INSTALL(DIRECTORY "${bindings_devel_dir}" DESTINATION "${CMAKE_INSTALL_PREFIX}/share")
