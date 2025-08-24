function(add_lesson LESSON_NAME)
  # Usage: add_lesson(<name> SOURCES main.cpp [extra.cpp...] [USE_UTILS]
  # [SHADERS file1.glsl file2.glsl ...] )

  set(options USE_UTILS)
  set(oneValueArgs)
  set(multiValueArgs SOURCES SHADERS)
  cmake_parse_arguments(AL "${options}" "${oneValueArgs}" "${multiValueArgs}"
                        ${ARGN})

  if(NOT AL_SOURCES)
    message(FATAL_ERROR "add_lesson(${LESSON_NAME}) requires SOURCES")
  endif()

  add_executable(${LESSON_NAME} ${AL_SOURCES})

  target_link_libraries(${LESSON_NAME} PRIVATE glfw glad::glad OpenGL::GL)

  target_include_directories(${LESSON_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

  if(AL_USE_UTILS)
    target_link_libraries(${LESSON_NAME} PRIVATE utils)
    target_compile_definitions(${LESSON_NAME} PRIVATE USE_LESSON_UTILS=1)
  endif()

  if(MSVC)
    target_compile_options(${LESSON_NAME} PRIVATE /W4 /permissive-)
  else()
    target_compile_options(${LESSON_NAME} PRIVATE -Wall -Wextra -Wpedantic)
  endif()

  # ---- Shader copying ----
  # set(_dst_dir "${CMAKE_BINARY_DIR}/bin/shaders") foreach(_shader
  # ${AL_SHADERS}) get_filename_component(_src "${_shader}" ABSOLUTE)
  # get_filename_component(_fname "${_shader}" NAME) add_custom_command( TARGET
  # ${LESSON_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} -E make_directory
  # "${_dst_dir}" COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_src}"
  # "${_dst_dir}/${_fname}" COMMENT "Copy shader ${_fname} -> ${_dst_dir}"
  # VERBATIM) endforeach()

  # --- Centralize exe outputs (if you haven't already done so globally) ---
  set_target_properties(${LESSON_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                                  ${CMAKE_BINARY_DIR}/bin)
  foreach(cfg Debug Release RelWithDebInfo MinSizeRel)
    set_target_properties(
      ${LESSON_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_${cfg}
                                ${CMAKE_BINARY_DIR}/bin/${cfg})
  endforeach()

  # --- Make VS debug sessions start in the same folder as the exe ---
  # This lets the program open "shaders/..." directly in VS.
  set_target_properties(
    ${LESSON_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY
                              "$<TARGET_FILE_DIR:${LESSON_NAME}>")

  # cmake --build <build> --target run_lesson_04_lighting
  add_custom_target(
    run_${LESSON_NAME}
    COMMAND ${CMAKE_COMMAND} -E chdir "$<TARGET_FILE_DIR:${LESSON_NAME}>"
            "$<TARGET_FILE:${LESSON_NAME}>"
    DEPENDS ${LESSON_NAME}
    USES_TERMINAL
    COMMENT "Running ${LESSON_NAME} from $<TARGET_FILE_DIR:${LESSON_NAME}>")

  # ---- Shader staging + runtime copy (no warnings, tracks changes) ----
  if(AL_SHADERS)
    # 1) Stage shaders in a config-independent folder (known at configure-time)
    # set(_stage_dir "${CMAKE_BINARY_DIR}/_shaders/${LESSON_NAME}")
    set(_stage_dir "${CMAKE_BINARY_DIR}/bin/shaders")
    set(_staged_outputs "")

    foreach(_shader ${AL_SHADERS})
      get_filename_component(_src "${_shader}" ABSOLUTE)
      get_filename_component(_fname "${_shader}" NAME)
      set(_dst "${_stage_dir}/${_fname}")

      list(APPEND _staged_outputs "${_dst}")

      # Produce a concrete OUTPUT so the build system knows when to re-run
      add_custom_command(
        OUTPUT "${_dst}"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${_stage_dir}"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_src}" "${_dst}"
        DEPENDS "${_src}"
        COMMENT "Stage shader ${_fname} -> ${_stage_dir}"
        VERBATIM)
    endforeach()

    # 2) A phony target that depends on staged outputs. This runs on normal
    # builds and when any shader changes.
    add_custom_target(
      sync_shaders_${LESSON_NAME} ALL
      DEPENDS ${_staged_outputs}
      COMMENT "Sync shaders for ${LESSON_NAME}")

    # 3) Ensure the lesson depends on the shader sync.
    add_dependencies(${LESSON_NAME} sync_shaders_${LESSON_NAME})

    # 4) After linking the lesson, copy the staged shaders next to the exe.
    # (Generator expression allowed in COMMAND, not in OUTPUT.)
    add_custom_command(
      TARGET ${LESSON_NAME}
      POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E make_directory
              "$<TARGET_FILE_DIR:${LESSON_NAME}>/shaders"
      COMMAND ${CMAKE_COMMAND} -E copy_directory "${_stage_dir}"
              "$<TARGET_FILE_DIR:${LESSON_NAME}>/shaders"
      COMMENT "Copy staged shaders -> $<TARGET_FILE_DIR:${LESSON_NAME}>/shaders"
      VERBATIM)
  endif()

endfunction()
