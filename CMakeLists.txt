PROJECT(satsolver-bindings)

cmake_minimum_required(VERSION 2.4)

#IF(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERISION} GREATER 2.4)
#ENDIF(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERISION} GREATER 2.4)

if(COMMAND cmake_policy)
  cmake_policy(SET CMP0003 NEW)
  # escape preprocessor, see -DVERSION below
  cmake_policy(SET CMP0005 OLD)
endif(COMMAND cmake_policy)

SET(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})


# satsolver version
FIND_PACKAGE(SatSolver)
IF (SATSOLVER_VERSION)
  MESSAGE(STATUS "Satsolver version ${SATSOLVER_VERSION}")
  ADD_DEFINITIONS( -DSATSOLVER_PACKAGE_MAJOR="${SATSOLVER_VERSION_MAJOR}")
  ADD_DEFINITIONS( -DSATSOLVER_PACKAGE_MINOR="${SATSOLVER_VERSION_MINOR}")
  ADD_DEFINITIONS( -DSATSOLVER_PACKAGE_PATCH="${SATSOLVER_VERSION_PATCH}")
ELSE (SATSOLVER_VERSION)
  MESSAGE(ERROR "Satsolver not found")
ENDIF (SATSOLVER_VERSION)

# Library
IF ( DEFINED LIB )
  SET ( LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/${LIB}" )
ELSE ( DEFINED  LIB )
  IF (CMAKE_SIZEOF_VOID_P MATCHES "8")
    SET( LIB_SUFFIX "64" )
  ENDIF(CMAKE_SIZEOF_VOID_P MATCHES "8")
  SET ( LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}" )
ENDIF ( DEFINED  LIB )
MESSAGE(STATUS "Libraries will be installed in ${LIB_INSTALL_DIR}" )
SET( BIN_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/bin" )

# RPM DB for reading the rpm database (via libsatsolverext)
IF ( NOT DEBIAN )
FIND_LIBRARY(RPMDB_LIBRARY NAMES rpmdb)
IF ( NOT RPMDB_LIBRARY )
FIND_LIBRARY(RPMDB_LIBRARY NAMES rpm)
ENDIF( NOT RPMDB_LIBRARY )
FIND_LIBRARY(RPMIO_LIBRARY NAMES rpmio)
IF ( RPMIO_LIBRARY )
SET( RPMDB_LIBRARY ${RPMIO_LIBRARY} ${RPMDB_LIBRARY} )
ENDIF ( RPMIO_LIBRARY )
IF ( FEDORA )
FIND_LIBRARY(DB_LIBRARY NAMES db)
IF ( DB_LIBRARY )
SET( RPMDB_LIBRARY ${DB_LIBRARY} ${RPMDB_LIBRARY} )
ENDIF ( DB_LIBRARY )
ENDIF ( FEDORA )
ENDIF ( NOT DEBIAN )


####################################################################
# CONFIGURATION                                                    #
####################################################################

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
SET( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules )

INCLUDE( ${CMAKE_SOURCE_DIR}/VERSION.cmake )

SET( PACKAGE "satsolver-bindings" )
SET( VERSION "${SATSOLVER_BINDINGS_MAJOR}.${SATSOLVER_BINDINGS_MINOR}.${SATSOLVER_BINDINGS_PATCH}" )
MESSAGE(STATUS "${PACKAGE} version ${VERSION}")

SET( SATSOLVER_INCLUDE_PATH "${CMAKE_INSTALL_PREFIX}/include/satsolver" )
SET( SATSOLVER_LIBRARY "satsolver" )
SET( SATSOLVERAPP_LIBRARY "satsolverapp" )
SET( SATSOLVEREXT_LIBRARY "satsolverext" )
SET( SATSOLVERTOOLS_LIBRARY "satsolvertools" )

ADD_DEFINITIONS( -D_FILE_OFFSET_BITS=64 )
ADD_DEFINITIONS( -DVERSION=\\\"${VERSION}\\\" )

SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "SAT Solver bindings")
SET(CPACK_PACKAGE_VENDOR "SUSE Linux Products GmbH")
SET(CPACK_PACKAGE_VERSION_MAJOR ${SATSOLVER_BINDINGS_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${SATSOLVER_BINDINGS_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${SATSOLVER_BINDINGS_PATCH})
SET(CPACK_GENERATOR "TBZ2")
SET(CPACK_SOURCE_GENERATOR "TBZ2")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${PACKAGE}-${VERSION}")
SET(CPACK_SOURCE_TOPLEVEL_TAG "Linux-Source:")
SET(CPACK_TOPLEVEL_TAG "Linux-Source:")

# The following components are regex's to match anywhere (unless anchored)
# in absolute path + filename to find files or directories to be excluded
# from source tarball.
SET (CPACK_SOURCE_IGNORE_FILES
# temporary files
"\\\\.swp$"
# backup files
"~$"
# eclipse files
"\\\\.cdtproject$"
"\\\\.cproject$"
"\\\\.project$"
"\\\\.settings/"
# others
"\\\\.#"
"/#"
"/build/"
"/_build/"
"/\\\\.git/"
# used before
"/\\\\.libs/"
"/\\\\.deps/"
"\\\\.o$"
"\\\\.lo$"
"\\\\.la$"
"Makefile$"
"Makefile\\\\.in$"
# cmake cache files
"DartConfiguration.tcl$"
"CMakeCache.txt"
"CMakeFiles"
"cmake_install.cmake$"
"CMakeLists.txt.auto$"
"CTestTestfile.cmake"
"CPackConfig.cmake$"
"CPackSourceConfig.cmake$"
"satsolver-bindings.spec$"
)

INCLUDE(CPack)

####################################################################

SET( DOC_INSTALL_DIR
   "${CMAKE_INSTALL_PREFIX}/share/doc/packages/${PACKAGE}"
   CACHE PATH "The install dir for documentation (default prefix/share/doc/packages/${PACKAGE})"
   FORCE
)

####################################################################
# INCLUDES                                                         #
####################################################################

#SET (CMAKE_INCLUDE_DIRECTORIES_BEFORE ON)
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_SOURCE_DIR} ${CMAKE_SOURCE_DIR}/src ${CMAKE_SOURCE_DIR}/ext ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/src SYSTEM )

####################################################################

MESSAGE(STATUS "Looking modules in ${CMAKE_MODULE_PATH}")

set ( CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -Wall" )
set ( CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS} -g -O3" )
set ( CMAKE_C_FLAGS_DEBUG     "${CMAKE_C_FLAGS} -g3 -O0 -Werror" )


ADD_SUBDIRECTORY(applayer)

FIND_PACKAGE(SWIG)

IF ( SWIG_FOUND )
  ADD_SUBDIRECTORY(bindings)
ELSE ( SWIG_FOUND )
 # for older version of swig/cmake
 FIND_PROGRAM(SWIG_EXECUTABLE
   NAMES swig-1.3 swig
  PATHS ${SWIG_DIR} ${SWIG_DIR}/.. ${SWIG_DIR}/../../bin /usr/bin /usr/local/bin ${CMAKE_INSTALL_PREFIX}/bin
 )
 IF ( SWIG_EXECUTABLE )
  ADD_SUBDIRECTORY(bindings)
 ELSE ( SWIG_EXECUTABLE )
  MESSAGE(ERROR, "Could not find SWIG")
 ENDIF ( SWIG_EXECUTABLE )
ENDIF ( SWIG_FOUND )

MESSAGE(STATUS "version: ${VERSION}")

####################################################################
# RPM SPEC                                                         #
####################################################################

MACRO(SPECFILE)
  MESSAGE(STATUS "Writing spec file...")
  CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/package/satsolver-bindings.spec.in ${CMAKE_BINARY_DIR}/package/satsolver-bindings.spec @ONLY)
  #MESSAGE(STATUS "I hate you rpm-lint...!!!")
  #CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/package/satsolver-bindings-rpmlint.cmake ${CMAKE_BINARY_DIR}/package/satsolver-bindings-rpmlintrc @ONLY)
ENDMACRO(SPECFILE)

SPECFILE()

SET( AUTOBUILD_COMMAND
  COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_BINARY_DIR}/package/*.tar.bz2
  COMMAND mkdir -p _CPack_Packages/${CPACK_TOPLEVEL_TAG}
  COMMAND ${CMAKE_MAKE_PROGRAM} package_source
  COMMAND ${CMAKE_COMMAND} -E copy ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.bz2 ${CMAKE_BINARY_DIR}/package
  COMMAND ${CMAKE_COMMAND} -E remove ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.bz2
  COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_SOURCE_DIR}/package/satsolver-bindings.changes" "${CMAKE_BINARY_DIR}/package/satsolver-bindings.changes"
)

ADD_CUSTOM_TARGET( srcpackage_local
  ${AUTOBUILD_COMMAND}
)

ADD_CUSTOM_TARGET( srcpackage
  ${AUTOBUILD_COMMAND}
)

INCLUDE(CTest)
ENABLE_TESTING()
