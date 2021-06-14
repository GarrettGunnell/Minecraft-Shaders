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

const float _Ambient = 0.095f;
const float _ShadowBias = 0.0002f;

vec3 sunDirection = normalize(sunPosition);
float sunVisibility  = clamp((dot( sunDirection, upPosition) + 0.05) * 10.0, 0.0, 1.0);
float moonVisibility = clamp((dot(-sunDirection, upPosition) + 0.05) * 10.0, 0.0, 1.0);

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;
    albedo = pow(albedo, vec4(2.2));

    vec2 lightmap = uv.zw;
    vec3 torchColor = vec3(1.0f);
    vec3 torchLight = lightmap.x * torchColor;
    vec3 skyLight = lightmap.y * skyColor;

    vec3 lightColor = torchLight + skyLight;

    float ndotl = clamp(dot(normal, sunDirection), 0.0f, 1.0f) * sunVisibility;
    ndotl += clamp(dot(normal, -sunDirection), 0.0f, 1.0f) * moonVisibility;
    ndotl *= luminance(skyColor);
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