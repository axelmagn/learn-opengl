#include "utils.hpp"
#include <GLFW/glfw3.h>

namespace utils {
  void set_window_title(void* glfwWindowPtr, const std::string& title) {
    auto* win = static_cast<GLFWwindow*>(glfwWindowPtr);
    glfwSetWindowTitle(win, title.c_str());
  }
}
