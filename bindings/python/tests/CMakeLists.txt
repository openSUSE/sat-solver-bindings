#
# CMakeLists.txt for sat-solver/bindings/python/tests
#

ENABLE_TESTING()

ADD_TEST(bindings_python_loading   ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} loading.py )
ADD_TEST(bindings_python_filelist  ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} filelist.py )
ADD_TEST(bindings_python_pool      ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} pool.py )
#ADD_TEST(bindings_python_problems  ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} problems.py )
ADD_TEST(bindings_python_providers ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} providers.py )
ADD_TEST(bindings_python_relation  ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} relation.py )
ADD_TEST(bindings_python_repodata  ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} repodata.py )
ADD_TEST(bindings_python_repo      ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} repo.py )
ADD_TEST(bindings_python_rpmdb     ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} rpmdb.py )
ADD_TEST(bindings_python_search    ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} search.py )
ADD_TEST(bindings_python_solvable  ${CMAKE_CURRENT_SOURCE_DIR}/run ${CMAKE_CURRENT_SOURCE_DIR} solvable.py )
