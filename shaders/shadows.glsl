#include "distort.glsl"

#define SHADOW_SAMPLES 3
const int shadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int totalSamples = shadowSamplesPerSize * shadowSamplesPerSize;

const int shadowMapResolution = 1024;

uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

float Visible(in sampler2D shadowMap, in vec3 uv, float bias) {
    return step(uv.z - bias, texture2D(shadowMap, uv.xy).r);
}

vec3 shadowColor(in vec3 uv, float bias) {
    float shadowVisibility0 = Visible(shadowtex0, uv, bias);
    float shadowVisibility1 = Visible(shadowtex1, uv, bias);

    vec4 shadowColor0 = texture2D(shadowcolor0, uv.xy);
    vec3 transmittedColor = shadowColor0.rgb * (1.0f - shadowColor0.a);

    return mix(transmittedColor * shadowVisibility1, vec3(1.0f), shadowVisibility0);
}

vec3 GetShadow(vec3 clipSpace, float bias, sampler2D noisetex) {
    vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0f);
    vec3 view = viewW.xyz / viewW.w;

    vec4 world = gbufferModelViewInverse * vec4(view, 1.0f);
    vec4 shadowSpace = shadowProjection * shadowModelView * world;

    shadowSpace.xy = DistortPosition(shadowSpace.xy);
    vec3 shadowUV = shadowSpace.xyz * 0.5f + 0.5f;

    float randomAngle = texture2D(noisetex, view.xy * 20.0f).r * 100.0f;
    float cosTheta = cos(randomAngle);
    float sinTheta = sin(randomAngle);
    mat2 rotation = mat2(cosTheta, -sinTheta, sinTheta, cosTheta) / shadowMapResolution;

    vec3 shadowAccum = vec3(0.0f);
    for (int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; ++x) {
        for (int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; ++y) {
            vec2 offset = rotation * vec2(x, y);
            vec3 currentSampleCoordinate = vec3(shadowUV.xy + offset, shadowUV.z);
            shadowAccum += shadowColor(currentSampleCoordinate, bias);
        }
    }

    shadowAccum /= totalSamples;
    return shadowAccum;
}