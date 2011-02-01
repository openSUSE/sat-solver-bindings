#
# CMakeLists.txt for sat-solver/applayer
#

ADD_SUBDIRECTORY(tests)

INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR} )
INCLUDE_DIRECTORIES( ${SATSOLVER_INCLUDE_PATH} )

SET(libsatsolverapp_SRCS job.c applayer.c covenant.c decision.c dependency.c
      kinds.c problem.c relation.c ruleinfo.c solution.c step.c request.c xrepokey.c xsolvable.c)

ADD_LIBRARY(satsolverapp STATIC ${libsatsolverapp_SRCS})

SET(libsatsolverapp_HEADERS job.h applayer.h covenant.h decision.h dependency.h
      kinds.h problem.h relation.h solution.h step.h request.h ruleinfo.h xrepokey.h xsolvable.h)

SET( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -Wall -Werror" )

INSTALL(  FILES ${libsatsolverapp_HEADERS} DESTINATION
"${CMAKE_INSTALL_PREFIX}/include/satsolver-app" )
INSTALL(TARGETS satsolverapp LIBRARY DESTINATION ${LIB_INSTALL_DIR} ARCHIVE DESTINATION ${LIB_INSTALL_DIR})
