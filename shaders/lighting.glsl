#include "shadows.glsl"

uniform sampler2D noisetex;

uniform float viewWidth, viewHeight;
uniform float rainStrength;

uniform vec3 skyColor;
uniform vec3 sunPosition;
uniform vec3 upPosition;

vec3 sunColor = vec3(0.98f, 0.73f, 0.15f);
vec3 moonColor = vec3(0.9725f, 0.9765f, 0.9765f);

const vec3 _Ambient = vec3(0.02f, 0.04f, 0.08f);
const float _ShadowBias = 0.0002f;

float AdjustTorchLighting(in float torchLight) {
    return max(3 * pow(torchLight, 4), 0.0f);
}

float AdjustSkyLighting(in float skyLight) {
    return max(pow(skyLight, 3), 0.0f);
}

vec2 AdjustLightmap(in vec2 lightmap) {
    vec2 newLightmap = lightmap;
    newLightmap.r = AdjustTorchLighting(lightmap.r);
    newLightmap.g = AdjustSkyLighting(lightmap.g);

    return newLightmap;
}

vec3 CalculateLighting(vec3 albedo, vec3 normal, vec2 lightmapCoords, vec3 fragCoords) {
    vec3 sunDirection = mat3(gbufferModelViewInverse) * (sunPosition * 0.01);
    float sunVisibility  = clamp((dot( sunDirection, upPosition) + 0.05) * 10.0, 0.0, 1.0);
    float moonVisibility = clamp((dot(-sunDirection, upPosition) + 0.05) * 10.0, 0.0, 1.0);

    vec2 lightmap = AdjustLightmap(lightmapCoords);
    vec3 torchColor = vec3(0.98f, 0.68f, 0.55f);
    vec3 torchLight = lightmap.x * torchColor;
    vec3 skyLight = lightmap.y * skyColor;

    vec3 lightColor = torchLight + skyLight;

    vec3 ndotl = sunColor * clamp(4 * dot(normal, sunDirection), 0.0f, 1.0f) * sunVisibility;
    ndotl += moonColor * clamp(4 * dot(normal, -sunDirection), 0.0f, 1.0f) * moonVisibility;
    ndotl *= 1.3;
    ndotl *= (luminance(skyColor) + 0.01f);
    ndotl *= lightmap.g;

    vec3 lighting = ndotl + lightColor + _Ambient;
    vec3 clipSpace = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z) * 2.0f - 1.0f;
    vec3 shadow = GetShadow(clipSpace, _ShadowBias, noisetex) + (lightColor / 10.0f);
    shadow = mix(shadow, 0.2f + (lightColor / 2.0f), rainStrength);

    vec3 diffuse = albedo.rgb;
    diffuse *= lighting;
    diffuse *= shadow;

    return diffuse;
}