#version 330 core

layout (location = 0) in vec3 aPos; // set vertex position start position in vertex attributes (stride is 12 bytes)
layout (location = 1) in vec3 aColor; // read from vertex attributes
layout (location = 2) in vec2 aTexcoord;

out vec4 vertexPosiotn;
out vec4 myVertexColor;
out vec2 TexCoord;

uniform float xOffset;

void main()
{
	gl_Position = vec4(aPos.x + xOffset, -aPos.y, aPos.z, 1.0);
	vertexPosiotn = gl_Position;
	myVertexColor = vec4(aColor, 1.0f);
	TexCoord = aTexcoord;
};
