# - Find Satsolver
# This module finds if libsatsolver-devel is installed and determines
# its version

#  SATSOLVER_VERSION = x.y.z

# Copyright (c) 2011 Klaus Kaempf <kkaempf@gmail.com>.  All rights reserved.
# BSD license


if(SATSOLVER_VERSION)
   # Already in cache, be silent
   set(SATSOLVER_FIND_QUIETLY TRUE)
endif (SATSOLVER_VERSION)

# Prefer a local (non-rpm) installation first

IF(EXISTS /usr/include/satsolver/satversion.h)
  MESSAGE(STATUS "satversion.h found")
  EXECUTE_PROCESS(COMMAND "grep" "SATSOLVER_VERSION_STRING" "/usr/include/satsolver/satversion.h" OUTPUT_VARIABLE SATSOLVER_VERSION_STRING)
#  MESSAGE(STATUS "Grep returned '${SATSOLVER_VERSION_STRING}'")
  STRING(REGEX REPLACE ".*([0-9]+\\.[0-9]+\\.[0-9]+).*" "\\1" SATSOLVER_VERSION "${SATSOLVER_VERSION_STRING}")
  MESSAGE(STATUS "Version '${SATSOLVER_VERSION}'")
  SET(HAVE_SATVERSION_H 1)
ELSE(EXISTS /usr/include/satsolver/satversion.h)
  SET(HAVE_SATVERSION_H 0)
ENDIF(EXISTS /usr/include/satsolver/satversion.h)

# Look for libsatsolver-devel

IF("${SATSOLVER_VERSION}" STREQUAL "")
  MESSAGE(STATUS "Looking for libsatsolver-devel")
  SET(RPM_EXECUTABLE "rpm")
  EXECUTE_PROCESS(COMMAND ${RPM_EXECUTABLE} -q "--queryformat" "%{version}" "libsatsolver-devel" OUTPUT_VARIABLE SATSOLVER_VERSION)
  STRING(REPLACE "\n" "" SATSOLVER_VERSION "${SATSOLVER_VERSION}")
  IF("${SATSOLVER_VERSION}" MATCHES ".*not installed.*")
    SET(SATSOLVER_VERSION "")
  ENDIF("${SATSOLVER_VERSION}" MATCHES ".*not installed.*")
ENDIF("${SATSOLVER_VERSION}" STREQUAL "")
    
IF("${SATSOLVER_VERSION}" STREQUAL "")
  MESSAGE(WARNING "Cant determine SATSOLVER_VERSION")
ELSE("${SATSOLVER_VERSION}" STREQUAL "")
  STRING(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)" DISCARD "${SATSOLVER_VERSION}")
  SET(SATSOLVER_VERSION_MAJOR ${CMAKE_MATCH_1})
  SET(SATSOLVER_VERSION_MINOR ${CMAKE_MATCH_2})
  SET(SATSOLVER_VERSION_PATCH ${CMAKE_MATCH_3})
ENDIF("${SATSOLVER_VERSION}" STREQUAL "")

MARK_AS_ADVANCED(
  SATSOLVER_VERSION
  )
