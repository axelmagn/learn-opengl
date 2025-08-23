cmake_minimum_required(VERSION 3.21)
project(LearnOpenGLTemplate LANGUAGES CXX)

# Put all executables under build/bin and all libs under build/lib
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# For multi-config generators (Visual Studio), also set per-config dirs
foreach(OUTPUTCONFIG Debug Release RelWithDebInfo MinSizeRel)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin/${OUTPUTCONFIG})
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib/${OUTPUTCONFIG})
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib/${OUTPUTCONFIG})
endforeach()

# Options
option(BUILD_UTILS "Build shared utils static library" ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Helper to add lesson executables
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(AddLesson)

# Dependencies:
# - With vcpkg toolchain, CONFIG packages will be found automatically.
find_package(glfw3 CONFIG REQUIRED)
find_package(glad CONFIG REQUIRED)
find_package(OpenGL REQUIRED)  # provides OpenGL::GL

# (Optional) shared utils library
if (BUILD_UTILS)
  add_subdirectory(src/common)
endif()

# Lessons (add as many as you like)
add_subdirectory(src/lessons/01_hello_window)
add_subdirectory(src/lessons/02_hello_triangle)
