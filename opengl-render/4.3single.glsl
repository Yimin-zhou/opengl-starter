#version 330 core
out vec4 FragColor;

in vec2 TexCoords;
uniform sampler2D alphaTex;

void main()
{    
	vec4 tex = texture2D(alphaTex, TexCoords);
	FragColor = tex;
}