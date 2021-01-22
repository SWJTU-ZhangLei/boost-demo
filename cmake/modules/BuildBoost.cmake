# Build boost by zhanglei

if (${CMAKE_CXX_COMPILER_ID} STREQUAL GNU)
  set(toolset gcc)
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL Clang)
  set(toolset clang)
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)
  set(toolset msvc)
else()
  message(SEND_ERROR "unknown compiler: ${CMAKE_CXX_COMPILER_ID}")
endif()

set(Boost_J "2" CACHE STRING "Boost -j")
set(Boost_SHA256 "953db31e016db7bb207f11432bef7df100516eeb746843fa0486a222e3fd49cb")
string(REPLACE "." "_" Boost_VERSION_UNDERSCORE ${Boost_VERSION})
set(Boost_URL 
  #"file:///${CMAKE_SOURCE_DIR}/third-parts/boost_${Boost_VERSION_UNDERSCORE}.tar.bz2"
  "https://dl.bintray.com/boostorg/release/${Boost_VERSION}/source/boost_${Boost_VERSION_UNDERSCORE}.tar.bz2"
)

message(STATUS "Boost_VERSION: ${Boost_VERSION}")
message(STATUS "Boost_URL: ${Boost_URL}")

set(boost_features "variant=release")
if(Boost_USE_MULTITHREADED)
  list(APPEND boost_features "threading=multi")
else()
  list(APPEND boost_features "threading=single")
endif()
if(Boost_USE_STATIC_LIBS)
  list(APPEND boost_features "link=static")
else()
  list(APPEND boost_features "link=shared")
endif()
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  list(APPEND boost_features "address-model=64")
else()
  list(APPEND boost_features "address-model=32")
endif()

if (WINDOWS)
  set(CONFIGURE_COMMAND ".\\\\bootstrap.bat")
  set(BUILD_COMMAND ".\\\\b2.exe" ${boost_features})
  set(INSTALL_COMMAND ".\\\\b2.exe" ${boost_features} "--prefix=<INSTALL_DIR>" "install")
else()
  set(CONFIGURE_COMMAND "./bootstrap.sh")
  set(BUILD_COMMAND "./b2" ${boost_features})
  set(INSTALL_COMMAND "./b2" ${boost_features} "--prefix=<INSTALL_DIR>" "install")
endif()

message(STATUS "Boost will be downloaded...")

set(CMAKELIST_CONTENT "
  cmake_minimum_required(VERSION ${CMAKE_MINIMUM_REQUIRED_VERSION})
  project(build_boost_project)
  set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE})
  include(ExternalProject)
  ExternalProject_Add(Boost 
    URL ${Boost_URL}
    URL_HASH SHA256=${Boost_SHA256}
    CONFIGURE_COMMAND ${CONFIGURE_COMMAND}
    BUILD_COMMAND ${BUILD_COMMAND}
    INSTALL_COMMAND ${INSTALL_COMMAND}
    PREFIX ${CMAKE_BINARY_DIR}/boost
    BUILD_IN_SOURCE 1
    LOG 1)
    ")

set(TARGET_DIR "${CMAKE_BINARY_DIR}/ExternalProjects/Boost")
file(WRITE "${TARGET_DIR}/CMakeLists.txt" "${CMAKELIST_CONTENT}")
file(MAKE_DIRECTORY "${TARGET_DIR}" "${TARGET_DIR}/build")

execute_process(COMMAND ${CMAKE_COMMAND} 
  ..
  WORKING_DIRECTORY "${TARGET_DIR}/build")

execute_process(COMMAND ${CMAKE_COMMAND}
  --build
  .
  --config 
  ${CMAKE_BUILD_TYPE}
  WORKING_DIRECTORY "${TARGET_DIR}/build")

# include(ExternalProject)
# ExternalProject_Add(Boost 
#   URL ${Boost_URL}
#   URL_HASH SHA256=${Boost_SHA256}
#   CONFIGURE_COMMAND ${CONFIGURE_COMMAND}
#   BUILD_COMMAND ${BUILD_COMMAND}
#   INSTALL_COMMAND ${INSTALL_COMMAND}
#   PREFIX "${CMAKE_BINARY_DIR}/boost"
#   BUILD_IN_SOURCE 1
#   LOG_DOWNLOAD 1
#   LOG_CONFIGURE 1
#   LOG_BUILD 1
#   LOG_INSTALL 1
# )
# ExternalProject_Get_Property(Boost install_dir)