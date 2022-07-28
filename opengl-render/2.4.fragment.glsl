#version 330 core
out vec4 FragColor;
in vec3 Normal;
in vec3 FragPos;
in vec2 TexCoords;

struct Material {
    sampler2D diffuse;
    sampler2D specular;
    sampler2D emission;
    float shininess;
};

struct Light {
    vec3 postion;
    vec3 lightColor;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform Material material;
uniform vec3 objectColor;
uniform vec3 viewPos;
uniform Light light;

void main()
{
    float specularStrength = 0.5;
    vec3 n = normalize(Normal);
    vec3 lightDir = normalize(light.postion - FragPos);
    float diff = max(0, dot(n, lightDir));
    vec3 diffuse = diff * texture(material.diffuse, TexCoords).rgb * light.diffuse * light.lightColor;

    vec3 ambient = texture(material.diffuse, TexCoords).rgb * light.ambient * light.lightColor;

    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, n);

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = spec * (texture(material.specular, TexCoords).rgb) * light.specular * light.lightColor;

    vec3 emission = texture(material.emission, TexCoords).rgb;
    vec3 result = (ambient + diffuse + specular + emission) * objectColor;
    FragColor = vec4(result, 1.0);
}