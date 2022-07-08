#version 330 core

out vec4 FragColor;
in vec4 vertexColor;
in vec3 myVertexColor;
in vec4 vertexPosiotn;

uniform vec4 myColor;

void main()
{
	FragColor = vertexPosiotn* myColor.x;
};