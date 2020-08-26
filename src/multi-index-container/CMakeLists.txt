if(Boost_FOUND)
  include_directories(${Boost_INCLUDE_DIRS})
  add_executable(multi-index-container-demo main.cpp)
endif()