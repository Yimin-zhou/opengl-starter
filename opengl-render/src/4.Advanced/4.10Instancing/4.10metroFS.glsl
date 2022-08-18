#version 330 core
out vec4 FragColor;
in vec3 Normal;
in vec3 FragPos;
in vec2 TexCoords;

uniform sampler2D texture_diffuse1;

void main()
{    
	FragColor = texture2D(texture_diffuse1, TexCoords);
}