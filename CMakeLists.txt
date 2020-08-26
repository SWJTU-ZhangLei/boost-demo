cmake_minimum_required(VERSION 3.0.0)
project(boost-demo)

set(CMAKE_CXX_STANDARD 11)

#参考路径
#https://cmake.org/cmake/help/v3.8/module/FindBoost.html?highlight=boost
set(Boost_NO_SYSTEM_PATHS ON)
set(Boost_USE_STATIC_LIBS ON)
set(BOOST_ROOT third-parts/boost_1_73_0)
find_package(boost 1.73.0 REQUIRED)
message(STATUS "Boost_FOUND: ${Boost_FOUND}")
add_subdirectory(src/multi-index-container)
