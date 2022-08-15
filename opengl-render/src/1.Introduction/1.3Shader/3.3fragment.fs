#version 330 core

out vec4 FragColor;
in vec4 vertexColor;
in vec3 myVertexColor;

uniform vec4 myColor;

void main()
{
	FragColor = vec4(myVertexColor, 1.0f) * myColor.x;
};