cmake_minimum_required(VERSION 3.0.0)
project(boost-demo)

set (USE_CONAN ON CACHE BOOL "Use Conan to acquire dependencies")

if (${USE_CONAN})
    include (./cmake/BoostDemoConan.cmake)
endif()

add_subdirectory(src/multi-index-container-demo)
