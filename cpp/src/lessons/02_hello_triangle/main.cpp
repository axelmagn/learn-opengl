#include <glad/glad.h>    // GLAD1 header
#include <GLFW/glfw3.h>
#include <cstdio>
#include <cstdlib>
#include <string>

#ifdef USE_LESSON_UTILS
  #include "../../common/utils.hpp"
#endif

static GLuint compile(GLenum type, const char* src) {
  GLuint s = glCreateShader(type);
  glShaderSource(s, 1, &src, nullptr);
  glCompileShader(s);
  GLint ok = 0; glGetShaderiv(s, GL_COMPILE_STATUS, &ok);
  if (!ok) {
    GLint len=0; glGetShaderiv(s, GL_INFO_LOG_LENGTH, &len);
    std::string log(len, '\0'); glGetShaderInfoLog(s, len, nullptr, log.data());
    std::fprintf(stderr, "shader error: %s\n", log.c_str());
  }
  return s;
}

int main() {
  if (!glfwInit()) { std::fprintf(stderr, "GLFW init failed\n"); return EXIT_FAILURE; }

#if defined(__APPLE__)
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GLFW_TRUE);
#endif
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

  GLFWwindow* window = glfwCreateWindow(800, 600, "Lesson 02 - Triangle", nullptr, nullptr);
  if (!window) { std::fprintf(stderr, "Window creation failed\n"); glfwTerminate(); return EXIT_FAILURE; }
  glfwMakeContextCurrent(window);
  glfwSwapInterval(1);

  // Load GL via GLAD1 (must be after context creation)
  if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
    std::fprintf(stderr, "Failed to load OpenGL via GLAD\n");
    glfwDestroyWindow(window); glfwTerminate(); return EXIT_FAILURE;
  }

#ifdef USE_LESSON_UTILS
  utils::set_window_title(window, "Lesson 02 - Triangle (utils linked)");
#endif

  const char* vsrc = R"(#version 330 core
    layout(location=0) in vec2 a_pos;
    void main(){ gl_Position = vec4(a_pos, 0.0, 1.0); }
  )";
  const char* fsrc = R"(#version 330 core
    out vec4 FragColor;
    void main(){ FragColor = vec4(1.0, 0.6, 0.2, 1.0); }
  )";
  GLuint vs = compile(GL_VERTEX_SHADER, vsrc);
  GLuint fs = compile(GL_FRAGMENT_SHADER, fsrc);
  GLuint prog = glCreateProgram();
  glAttachShader(prog, vs); glAttachShader(prog, fs);
  glLinkProgram(prog);
  glDeleteShader(vs); glDeleteShader(fs);

  const float verts[] = {
    -0.6f, -0.5f,
     0.6f, -0.5f,
     0.0f,  0.6f
  };
  GLuint vao=0, vbo=0;
  glGenVertexArrays(1, &vao); glBindVertexArray(vao);
  glGenBuffers(1, &vbo); glBindBuffer(GL_ARRAY_BUFFER, vbo);
  glBufferData(GL_ARRAY_BUFFER, sizeof(verts), verts, GL_STATIC_DRAW);
  glEnableVertexAttribArray(0);
  glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), (void*)0);

  while (!glfwWindowShouldClose(window)) {
    glfwPollEvents();
    glViewport(0, 0, 800, 600);
    glClearColor(0.08f, 0.1f, 0.12f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(prog);
    glBindVertexArray(vao);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glfwSwapBuffers(window);
  }

  glDeleteProgram(prog);
  glDeleteBuffers(1, &vbo);
  glDeleteVertexArrays(1, &vao);
  glfwDestroyWindow(window);
  glfwTerminate();
  return EXIT_SUCCESS;
}
