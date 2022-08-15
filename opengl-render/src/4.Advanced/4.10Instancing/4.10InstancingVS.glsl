#version 330 core
layout (location = 0) in vec2 aPos;
layout (location = 1) in vec3 aVertexColor;
layout (location = 2) in vec2 aOffset;

out vec3 fColor;
uniform vec2 offsets[100];

void main()
{  
    fColor = aVertexColor;
    vec2 offset = aOffset;
    gl_Position = vec4(aPos + offset, 0.0, 1.0);
}