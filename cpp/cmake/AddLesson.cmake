function(add_lesson LESSON_NAME)
  # Usage: add_lesson(<name> [SOURCES ...] [USE_UTILS])
  set(options USE_UTILS)
  set(oneValueArgs)
  set(multiValueArgs SOURCES)
  cmake_parse_arguments(AL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if (NOT AL_SOURCES)
    message(FATAL_ERROR "add_lesson(${LESSON_NAME}) requires SOURCES")
  endif()

  add_executable(${LESSON_NAME} ${AL_SOURCES})

  target_link_libraries(${LESSON_NAME}
    PRIVATE
      glfw
      glad::glad
      OpenGL::GL
  )

  target_include_directories(${LESSON_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

  if (AL_USE_UTILS)
    target_link_libraries(${LESSON_NAME} PRIVATE utils)
    target_compile_definitions(${LESSON_NAME} PRIVATE USE_LESSON_UTILS=1)
  endif()

  if (MSVC)
    target_compile_options(${LESSON_NAME} PRIVATE /W4 /permissive-)
  else()
    target_compile_options(${LESSON_NAME} PRIVATE -Wall -Wextra -Wpedantic)
  endif()
endfunction()

