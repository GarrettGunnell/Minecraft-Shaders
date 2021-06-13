#version 120
#include "distort.glsl"

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;
uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform float viewWidth, viewHeight;

uniform vec3 skyColor;
uniform vec3 sunPosition;
uniform vec3 upPosition;

float _Ambient = 0.095f;

const float sunPathRotation = -10.0f;
const int shadowMapResolution = 1024;
const float shadowBias = 0.0002f;

#define SHADOW_SAMPLES 2
const int shadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int totalSamples = shadowSamplesPerSize * shadowSamplesPerSize;

const int noiseTextureResolution = 128;

const float Ambient = 0.01f;

float Visible(in sampler2D shadowMap, in vec3 uv) {
    return step(uv.z - shadowBias, texture2D(shadowMap, uv.xy).r);
}

vec3 shadowColor(in vec3 uv) {
    float shadowVisibility0 = Visible(shadowtex0, uv);
    float shadowVisibility1 = Visible(shadowtex1, uv);

    vec4 shadowColor0 = texture2D(shadowcolor0, uv.xy);
    vec3 transmittedColor = shadowColor0.rgb * (1.0f - shadowColor0.a);

    return mix(transmittedColor * shadowVisibility1, vec3(1.0f), shadowVisibility0);
}

vec3 GetShadow(float depth) {
    vec3 clipSpace = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z) * 2.0f - 1.0f;
    vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0f);
    vec3 view = viewW.xyz / viewW.w;

    vec4 world = gbufferModelViewInverse * vec4(view, 1.0f);
    vec4 shadowSpace = shadowProjection * shadowModelView * world;

    shadowSpace.xy = DistortPosition(shadowSpace.xy);
    vec3 shadowUV = shadowSpace.xyz * 0.5f + 0.5f;

    float randomAngle = texture2D(noisetex, uv.xy * 20.0f).r * 100.0f;
    float cosTheta = cos(randomAngle);
    float sinTheta = sin(randomAngle);
    mat2 rotation = mat2(cosTheta, -sinTheta, sinTheta, cosTheta) / shadowMapResolution;

    vec3 shadowAccum = vec3(0.0f);
    for (int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; ++x) {
        for (int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; ++y) {
            vec2 offset = rotation * vec2(x, y);
            vec3 currentSampleCoordinate = vec3(shadowUV.xy + offset, shadowUV.z);
            shadowAccum += shadowColor(currentSampleCoordinate);
        }
    }

    shadowAccum /= totalSamples;
    return shadowAccum;
}

float luminance(vec3 color) {
    return dot(color, vec3(0.2125f, 0.7153f, 0.0721f));
}

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;
    albedo = pow(albedo, vec4(2.2));

    float depth = texture2D(depthtex0, uv.xy).r;

    vec2 lightmap = uv.zw;
    vec3 torchColor = vec3(1.0f);
    vec3 torchLight = lightmap.x * torchColor;
    vec3 skyLight = lightmap.y * skyColor;

    vec3 lightColor = torchLight + skyLight;

    vec3 sunDirection = normalize(sunPosition);
    float sunVisibility  = clamp((dot( sunDirection, upPosition) + 0.05) * 10.0, 0.0, 1.0);
    float moonVisibility = clamp((dot(-sunDirection, upPosition) + 0.05) * 10.0, 0.0, 1.0);

    float ndotl = clamp(dot(normal, sunDirection), 0.0f, 1.0f) * sunVisibility;
    ndotl += clamp(dot(normal, -sunDirection), 0.0f, 1.0f) * moonVisibility;
    ndotl *= luminance(skyColor);
    ndotl *= lightmap.g;

    vec3 lighting = ndotl + lightColor + _Ambient;
    vec3 shadow = GetShadow(depth) + _Ambient;

    vec3 diffuse = albedo.rgb * lighting * shadow;

    /* DRAWBUFFERS:012 */
    gl_FragData[0] = vec4(diffuse, albedo.a);
    //gl_FragData[0] = vec4(lightmap.rg, 0, 0);
    gl_FragData[1] = vec4((normal + 1.0f) / 2.0f, 1.0f);
    gl_FragData[2] = vec4(uv.zw, 0.0f, 1.0f);
}