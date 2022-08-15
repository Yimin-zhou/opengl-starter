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
    vec3 objectColor;
};

//POINT LIGHT
struct DirLight {
    vec3 direction;
    vec3 color;
    float intensity;
};

//POINT LIGHT
struct PointLight {
    vec3 position;
    vec3 color;
    float intensity;

    // Attenuation
    float constant;
    float linear;
    float quadratic;
};

// SPOT LIGHT
struct SpotLight {
    vec3  position;
    vec3  frontDir;
    float cutOff;
    float outerCutOff;
    vec3 color;
    float intensity;

    // Attenuation
    float constant;
    float linear;
    float quadratic;
};


#define NR_POINT_LIGTHS 4
uniform PointLight pointLights[NR_POINT_LIGTHS];

uniform Material material;
uniform vec3 viewPos;

uniform DirLight dirLight;
uniform SpotLight spotLight;

vec3 GetDirLighting(DirLight light, vec3 n, vec3 viewDir);
vec3 GetPointLighting(PointLight light, vec3 n, vec3 viewDir);
vec3 GetSpotLighting(SpotLight light, vec3 n, vec3 viewDir);

void main()
{
    vec3 n = normalize(Normal);
    vec3 v = normalize(viewPos - FragPos);

    vec3 result = GetDirLighting(dirLight, n, v);
    
    for(int i = 0; i < NR_POINT_LIGTHS; i++)
    {
        result += GetPointLighting(pointLights[i], n, v);
    }
    result += GetSpotLighting(spotLight, n, v);

    FragColor = vec4(result * material.objectColor, 1.0);
}

vec3 GetSpotLighting(SpotLight light, vec3 n, vec3 viewDir)
{
    float specularStrength = 0.5;
    vec3 lightDir = normalize(light.position - FragPos);
    vec3 spotDir = normalize(-light.frontDir);
    float theta = dot(lightDir, spotDir);
    float epsilon   = light.cutOff - light.outerCutOff;
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);    

    float diff = max(0, dot(n, lightDir));
    vec3 diffuse = diff * texture(material.diffuse, TexCoords).rgb * light.color * light.intensity;

    vec3 ambient = texture(material.diffuse, TexCoords).rgb * light.color * 0.5;

    vec3 reflectDir = reflect(-lightDir, n);

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = spec * (texture(material.specular, TexCoords).rgb) * light.color;

    
    // attenuation
    float dis = length(light.position - FragPos);
    float attenuation = 1.0 / (light.constant + light.linear * dis + light.quadratic * (dis * dis));

    diffuse   = diffuse * attenuation * intensity;
    specular = specular * attenuation * intensity;
    
//    vec3 emission = texture(material.emission, TexCoords).rgb;
    return vec3(diffuse + specular + ambient); 
}

vec3 GetDirLighting(DirLight light, vec3 n, vec3 viewDir)
{
    float specularStrength = 0.5;

    float diff = max(0, dot(n, light.direction));
    vec3 diffuse = diff * texture(material.diffuse, TexCoords).rgb * light.color * light.intensity;

    vec3 ambient = texture(material.diffuse, TexCoords).rgb * light.color * 0.5;

    vec3 reflectDir = reflect(-light.direction, n);

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = spec * (texture(material.specular, TexCoords).rgb) * light.color;
    return vec3(diffuse + specular + ambient); 
}

vec3 GetPointLighting(PointLight light, vec3 n, vec3 viewDir)
{
    vec3 lightDir = normalize(light.position - FragPos);
    // 漫反射着色
    float diff = max(dot(n, lightDir), 0.0);
    // 镜面光着色
    vec3 reflectDir = reflect(-lightDir, n);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // 衰减
    float distance    = length(light.position - FragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + 
                 light.quadratic * (distance * distance));    
    // 合并结果
    vec3 ambient  = vec3(texture(material.diffuse, TexCoords));
    vec3 diffuse  = diff * vec3(texture(material.diffuse, TexCoords));
    vec3 specular = spec * vec3(texture(material.specular, TexCoords));
    ambient  *= attenuation;
    diffuse  *= attenuation;
    specular *= attenuation;
    return (ambient + diffuse + specular);
}