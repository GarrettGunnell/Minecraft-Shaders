#version 120
#include "common.glsl"

varying float star;

uniform vec3 skyColor;
uniform vec3 upPosition;
uniform vec3 sunPosition;
uniform float viewWidth, viewHeight;
uniform float rainStrength;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

void main() {
    vec3 sunDirection = sunPosition * 0.01f;
    float sunVisibility  = clamp((dot( sunDirection, upPosition)), 0.0, 1.0);
    vec4 clipSpace = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z, 1.0f);
	vec4 viewW = gbufferProjectionInverse * (clipSpace * 2.0 - 1.0);
    viewW /= viewW.w;

    vec3 viewSpace = normalize(viewW.xyz) / 4;
    float vdotu = clamp(dot(viewSpace.xyz, upPosition) / 2, 0.0f, 1.0f);

    vec3 topDayGradient = vec3(0.40f, 0.48f, 0.65f);
    vec3 bottomDayGradient = vec3(0.72f, 0.73f, 0.8f);

    vec3 topNightGradient = vec3(0.02f, 0.02f, 0.03f);
    vec3 bottomNightGradient = vec3(0.02f, 0.0f, 0.03f);

    vec3 topGradient = mix(topNightGradient, topDayGradient, sunVisibility);
    vec3 bottomGradient = mix(bottomNightGradient, bottomDayGradient, sunVisibility);
    vec3 skyCol = mix(bottomGradient, topGradient, vdotu);

    skyCol *= mix(1.0, 0.25, rainStrength);
    vec3 desaturated = vec3(luminance(skyCol));
    skyCol = mix(desaturated, skyCol, 2.0f);

    if (vdotu > 0.0f)
        skyCol += star;

    skyCol = pow(skyCol, vec3(2.2));

    /* DRAWBUFFERS: 0 */
    gl_FragData[0] = vec4(skyCol, vdotu - rainStrength);
}