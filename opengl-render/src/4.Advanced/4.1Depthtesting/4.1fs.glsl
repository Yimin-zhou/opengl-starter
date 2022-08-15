#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D texture1;
float near = 0.1; 
float far  = 100.0; 

void main()
{    
	//FragColor = texture(texture1, TexCoords);
	float depth = gl_FragCoord.z; // non-linear in screen space
	float z = depth * 2.0 - 1.0; // ndc space

	// project matrix
	float linearDepth = (2.0 * near * far) / (far + near - z * (far - near)); // bigger than 1

	FragColor = vec4(vec3(depth), 1.0);
}