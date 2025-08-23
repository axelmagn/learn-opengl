add_lesson(02_hello_triangle
  SOURCES main.cpp
  USE_UTILS           # this one shows how to link utils (optional)
)


target_link_libraries(02_hello_triangle PRIVATE utils)
