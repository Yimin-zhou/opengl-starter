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

// POINT LIGHT
//struct Light {
//    vec3 lightDirection;
//    vec3 lightColor;
//    float intensity;
//
//    // Attenuation
//    float constant;
//    float linear;
//    float quadratic;
//};

// SPOT LIGHT
struct Light {
    vec3  position;
    vec3  direction;
    float cutOff;
    float outerCutOff;
    vec3 lightColor;
    float intensity;

    // Attenuation
    float constant;
    float linear;
    float quadratic;
};

uniform Material material;
uniform vec3 objectColor;
uniform vec3 viewPos;
uniform Light light;

void main()
{
    float specularStrength = 0.5;
    vec3 n = normalize(Normal);
    vec3 lightDir = normalize(light.position - FragPos);
    vec3 spotDir = normalize(-light.direction);
    float theta = dot(lightDir, spotDir);
    float epsilon   = light.cutOff - light.outerCutOff;
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);    


        float dis = length(light.position - FragPos);
        float attenuation = 1.0 / (light.constant + light.linear * dis + light.quadratic * (dis * dis));

        float diff = max(0, dot(n, lightDir));
        vec3 diffuse = diff * texture(material.diffuse, TexCoords).rgb * light.lightColor * light.intensity;

        vec3 ambient = texture(material.diffuse, TexCoords).rgb * light.lightColor * 0.5;

        vec3 viewDir = normalize(viewPos - FragPos);
        vec3 reflectDir = reflect(-lightDir, n);

        float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
        vec3 specular = spec * (texture(material.specular, TexCoords).rgb) * light.lightColor;

        diffuse   = diffuse * attenuation * intensity;
        specular = specular * attenuation * intensity;   
        vec3 emission = texture(material.emission, TexCoords).rgb;
        vec3 result = (diffuse + specular + ambient) * objectColor; 
        FragColor = vec4(result, 1.0);

}