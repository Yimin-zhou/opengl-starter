#version 330 core

out vec4 FragColor;
in vec4 myVertexColor;
in vec4 vertexPosiotn;
in vec2 TexCoord;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float mixNum = 0;

void main()
{
    FragColor = mix(texture(texture1, TexCoord), texture(texture2, vec2(TexCoord.x, -TexCoord.y)), mixNum);
}