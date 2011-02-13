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

SET(RPM_EXECUTABLE "rpm")

EXECUTE_PROCESS(COMMAND ${RPM_EXECUTABLE} -q "--queryformat"
"%{version}" "libsatsolver-devel"
OUTPUT_VARIABLE SATSOLVER_VERSION)

STRING(REPLACE "\n" "" SATSOLVER_VERSION "${SATSOLVER_VERSION}")

IF("${SATSOLVER_VERSION}" MATCHES ".*not installed.*")
  SET(SATSOLVER_VERSION "")
ELSE("${SATSOLVER_VERSION}" MATCHES ".*not installed.*")
  STRING(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)" DISCARD "${SATSOLVER_VERSION}")
  SET(SATSOLVER_VERSION_MAJOR ${CMAKE_MATCH_1})
  SET(SATSOLVER_VERSION_MINOR ${CMAKE_MATCH_2})
  SET(SATSOLVER_VERSION_PATCH ${CMAKE_MATCH_3})
ENDIF("${SATSOLVER_VERSION}" MATCHES ".*not installed.*")

MARK_AS_ADVANCED(
  SATSOLVER_VERSION
  )
