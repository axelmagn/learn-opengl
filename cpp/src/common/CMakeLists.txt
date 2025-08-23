add_library(utils STATIC utils.cpp)
target_include_directories(utils PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(utils PRIVATE glad::glad OpenGL::GL) # if your utils touch GL
if (MSVC)
  target_compile_options(utils PRIVATE /W4 /permissive-)
else()
  target_compile_options(utils PRIVATE -Wall -Wextra -Wpedantic)
endif()

