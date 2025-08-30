#ifndef SPRITE_RENDERER_H
#define SPRITE_RENDERER_H

#include <glad/glad.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>

#include "shader.h"
#include "texture.h"

class SpriteRenderer {
  public:
    SpriteRenderer(Shader shader);
    ~SpriteRenderer();

    void DrawSprite(const Texture2D& texture, glm::vec2 position,
                    glm::vec2 size = glm::vec2(10.f, 10.f), float rotate = 0.f,
                    glm::vec3 color = glm::vec3(1.f));

  private:
    Shader shader;
    unsigned int quadVAO;
    void initRenderData();
};

#endif
