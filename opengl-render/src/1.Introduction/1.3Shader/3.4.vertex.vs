#version 330 core

layout (location = 0) in vec3 aPos; // set vertex position start position in vertex attributes (stride is 12 bytes)
layout (location = 1) in vec3 aColor; // read from vertex attributes

out vec4 vertexColor;
out vec4 vertexPosiotn;
out vec3 myVertexColor;

uniform float xOffset;

void main()
{
	gl_Position = vec4(aPos.x + xOffset, -aPos.y, aPos.z, 1.0);
	vertexPosiotn = gl_Position;
	vertexColor = vec4(0.5, 0.0, 0.0, 1.0);
	myVertexColor = aColor;
};