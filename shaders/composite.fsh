#version 120

varying vec2 uv;

uniform vec3 sunPosition;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

/*
const int colortex0Format = RGBA16;
const int colortex1Format = RGBA16;
const int colortex2Format = RGB16;
*/

const float sunPathRotation = -40.0f;
const float Ambient = 0.1f;

float AdjustTorchMap(in float torch) {
    const float K = 2.0f;
    const float P = 5.06f;

    return K * pow(torch, P);
}  

float AdjustSkyMap(in float sky) {
    return sky * sky * sky * sky;
}

vec2 AdjustLightmap(in vec2 lightmap) {
    vec2 newLightmap;
    newLightmap.r = AdjustTorchMap(lightmap.r);
    newLightmap.g = AdjustSkyMap(lightmap.g);

    return newLightmap;
}

vec3 DetermineLightColor(in vec2 lightmap) {
    vec3 torchColor = vec3(1.0f, 0.25f, 0.08f);
    vec3 skyColor = vec3(0.05f, 0.15f, 0.3f);

    vec3 torchLighting = lightmap.x * torchColor;
    vec3 skyLighting = lightmap.y * skyColor;

    return torchLighting + skyLighting;
}

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo = pow(albedo, vec3(2.2f)); // gamma correct

    vec3 normal = texture2D(colortex1, uv).rgb;
    normal = normal * 2.0f - 1.0f; // unpack normal

    vec2 lightmap = AdjustLightmap(texture2D(colortex2, uv).rg);
    vec3 lightColor = DetermineLightColor(lightmap);

    float ndotl = max(dot(normal, normalize(sunPosition)), 0.0f);

    vec3 diffuse = albedo * (lightColor + ndotl + Ambient);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(diffuse, 1.0f);
    //gl_FragData[0] = vec4(lightmap.rg, 0, 0);
}