#
# CMakeLists.txt for sat-solver/bindings/python/tests
#

ENABLE_TESTING()

ADD_TEST(bindings_python_loading    ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} loading.py )
