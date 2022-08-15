#version 330 core

layout (location = 0) in vec3 aPos; // set vertex position start position in vertex attributes (stride is 12 bytes)
layout (location = 1) in vec3 aColor; // read from vertex attributes

out vec4 vertexColor;
out vec3 myVertexColor;

void main()
{
	gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
	vertexColor = vec4(0.5, 0.0, 0.0, 1.0);
	myVertexColor = aColor;
};