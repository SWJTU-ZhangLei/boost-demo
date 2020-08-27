cmake_minimum_required(VERSION 3.0.0)
project(boost-demo)

# The version number.
set(BOOST_DEMO_VERSION_MAJOR 1)

set(BOOST_DEMO_VERSION_MINOR 0)

set(BOOST_DEMO_VERSION_PATCH 0)

set(CMAKE_CXX_STANDARD 11)

option(BUILD_SHARED_LIBS "Option for generating dynamic or static library." OFF)

#参考路径
#https://cmake.org/cmake/help/v3.8/module/FindBoost.html?highlight=boost
set(Boost_NO_SYSTEM_PATHS ON)

if (BUILD_SHARED_LIBS)
  message(STATUS "Dynamic library")
  set(Boost_USE_STATIC_LIBS OFF) # only find static libs
else()
  message(STATUS "Static library")
  set(Boost_USE_STATIC_LIBS ON) # only find static libs
endif()

set(Boost_USE_DEBUG_LIBS OFF) # ignore debug libs and

set(Boost_USE_RELEASE_LIBS ON)  # only find release libs

set(Boost_USE_MULTITHREADED ON)

set(Boost_USE_STATIC_RUNTIME OFF)

set(BOOST_ROOT third-parts/boost_1_73_0)

set(Boost_NO_BOOST_CMAKE ON) 
find_package(Boost 1.73.0 MODULE REQUIRED COMPONENTS regex REQUIRED)

message(STATUS "Boost_FOUND: ${Boost_FOUND}")

message(STATUS "Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")

message(STATUS "Boost_LIBRARY_DIRS: ${Boost_LIBRARY_DIRS}")

message(STATUS "Boost_LIBRARIES: ${Boost_LIBRARIES}")

add_subdirectory(src/multi-index-container)

add_subdirectory(src/regex)

include (InstallRequiredSystemLibraries)

set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")

set(CPACK_PACKAGE_VERSION_MAJOR "${BOOST_DEMO_VERSION_MAJOR}")

set(CPACK_PACKAGE_VERSION_MINOR "${BOOST_DEMO_VERSION_MINOR}")

set(CPACK_PACKAGE_VERSION_PATCH "${BOOST_DEMO_VERSION_PATCH}")

include (CPack)