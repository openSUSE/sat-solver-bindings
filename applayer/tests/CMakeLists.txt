#
# CMakeLists.txt for sat-solver/applayer/tests
#

INCLUDE_DIRECTORIES( ${SATSOLVER_INCLUDE_PATH} )
INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR}/applayer )

SET( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Werror" )

ADD_EXECUTABLE( applayer applayer.c )
TARGET_LINK_LIBRARIES( applayer appsatsolver satsolver )
