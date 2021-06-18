#version 120

#include "settings.glsl"
#include "common.glsl"
#include "shadows.glsl"

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;
uniform sampler2D noisetex;

uniform float viewWidth, viewHeight;

uniform vec3 skyColor;
uniform vec3 sunPosition;
uniform vec3 upPosition;

const vec3 _Ambient = vec3(0.02f, 0.04f, 0.08f);
const float _ShadowBias = 0.0002f;

vec3 sunColor = vec3(0.98f, 0.73f, 0.15f);
vec3 moonColor = vec3(0.9725f, 0.9765f, 0.9765f);

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

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;
    albedo = pow(albedo, vec4(2.2));

        //vec4 world = gbufferModelViewInverse * vec4(view, 1.0f);

    vec3 sunDirection = mat3(gbufferModelViewInverse) * (sunPosition * 0.01);
    float sunVisibility  = clamp((dot( sunDirection, upPosition) + 0.05) * 10.0, 0.0, 1.0);
    float moonVisibility = clamp((dot(-sunDirection, upPosition) + 0.05) * 10.0, 0.0, 1.0);

    vec2 lightmap = AdjustLightmap(uv.zw);
    vec3 torchColor = vec3(0.98f, 0.68f, 0.55f);
    vec3 torchLight = lightmap.x * torchColor;
    vec3 skyLight = lightmap.y * skyColor;

    vec3 lightColor = torchLight + skyLight;

    vec3 newNormal = normalize(normal);
    newNormal.y *= 0.3;
    vec3 ndotl = sunColor * clamp(dot(newNormal, sunDirection), 0.0f, 1.0f) * sunVisibility;
    ndotl += moonColor * clamp(dot(newNormal, -sunDirection), 0.0f, 1.0f) * moonVisibility;
    ndotl *= 4;
    ndotl *= (luminance(skyColor) + 0.01f);
    ndotl *= lightmap.g;

    vec3 lighting = ndotl + lightColor + _Ambient;
    vec3 clipSpace = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z) * 2.0f - 1.0f;
    vec3 shadow = GetShadow(clipSpace, _ShadowBias, noisetex) + (lightColor / 2.0f) + _Ambient;

    vec3 diffuse = albedo.rgb * lighting * shadow;

    /* DRAWBUFFERS:012 */
    gl_FragData[0] = vec4(diffuse, albedo.a);
    //gl_FragData[0] = vec4(lightmap.rg, 0, 0);
    gl_FragData[1] = vec4((normal + 1.0f) / 2.0f, 1.0f);
    gl_FragData[2] = vec4(uv.zw, 0.0f, 1.0f);
}