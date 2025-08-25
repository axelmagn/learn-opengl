add_lesson(
  031_shaders_uniform SOURCES shaders_uniform.cpp USE_UTILS # this one shows how
                                                            # to link utils
                                                            # (optional)
)
add_lesson(
  032_shaders_interpolation SOURCES shaders_interpolation.cpp
  USE_UTILS # this one shows how to link utils (optional)
)
add_lesson(
  033_shaders_class
  SOURCES
  shaders_class.cpp
  ASSETS
  033.shader.fs
  033.shader.vs
  USE_UTILS # this one shows how to link utils (optional)
)

add_lesson(
  034_exercise01
  SOURCES
  exercise01.cpp
  ASSETS
  034.shader.fs
  034.shader.vs
  USE_UTILS # this one shows how to link utils (optional)
)

add_lesson(
  035_exercise02
  SOURCES
  exercise02.cpp
  ASSETS
  035.shader.fs
  035.shader.vs
  USE_UTILS # this one shows how to link utils (optional)
)

add_lesson(
  036_exercise03
  SOURCES
  exercise03.cpp
  ASSETS
  036.shader.fs
  036.shader.vs
  USE_UTILS # this one shows how to link utils (optional)
)
