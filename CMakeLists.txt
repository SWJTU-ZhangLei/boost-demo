cmake_minimum_required(VERSION 3.0.0)
project(boost-demo)

# The version number.
set(${PROJECT_NAME}_version_major 1)
set(${PROJECT_NAME}_version_minor 0)
set(${PROJECT_NAME}_version_patch 0)

set(CMAKE_CXX_STANDARD 11)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules/")

option(BUILD_SHARED_LIBS "Option for generating dynamic or static library." ON)
option(WITH_SYSTEM_BOOST "Require and build with system Boost" OFF)
set(CMAKE_BUILD_TYPE "Release")

message(STATUS "CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
if(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(LINUX ON CACHE BOOL "Linux")
elseif(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
  set(FREEBSD ON CACHE BOOL "FreeBSD")
elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(WINDOWS ON CACHE BOOL "Windows")
else()
  message(SEND_ERROR "Unknown system: ${CMAKE_SYSTEM_NAME}")
endif()

set(Boost_VERSION "1.75.0" CACHE STRING "Boost version.")
set(Boost_COMPONENTS "date_time" "regex" "filesystem" CACHE STRING "Boost components.")
set(Boost_USE_STATIC_LIBS ON) # only find static libs
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)

if(WITH_SYSTEM_BOOST)
  if(BUILD_SHARED_LIBS)
    set(Boost_USE_STATIC_LIBS OFF)
  endif()
  message(STATUS "WITH_SYSTEM_BOOST: ${WITH_SYSTEM_BOOST}")
else()
  include(BuildBoost)
  set(BOOST_ROOT "${CMAKE_BINARY_DIR}/boost")
endif()

find_package(Boost ${Boost_VERSION} REQUIRED COMPONENTS ${Boost_COMPONENTS} REQUIRED)

message(STATUS "Boost_FOUND: ${Boost_FOUND}")
message(STATUS "Boost_INCLUDE_DIR: ${Boost_INCLUDE_DIR}")
message(STATUS "Boost_LIBRARY_DIRS: ${Boost_LIBRARY_DIRS}")
# message(STATUS "Boost_LIBRARY_DIR_RELEASE: ${Boost_LIBRARY_DIR_RELEASE}")
# message(STATUS "Boost_LIBRARY_DIR_DEBUG: ${Boost_LIBRARY_DIR_DEBUG}")

foreach(c ${Boost_COMPONENTS})
  string(TOUPPER ${c} upper_c)
  message(STATUS "Boost_${upper_c}_LIBRARY_DEBUG: ${Boost_${upper_c}_LIBRARY_DEBUG}")
  message(STATUS "Boost_${upper_c}_LIBRARY_RELEASE: ${Boost_${upper_c}_LIBRARY_RELEASE}")
endforeach()

# add_subdirectory(src/multi-index-container)
# add_subdirectory(src/regex)
add_subdirectory(src/asio)

include (InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_NAME}_version_major")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_NAME}_version_minor")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_NAME}_version_patch")
include (CPack)