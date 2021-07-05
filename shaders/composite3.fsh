#version 120
#include "common.glsl"

varying vec2 uv;
uniform sampler2D colortex0;
uniform sampler2D colortex4;
uniform sampler2D depthtex0;

/*
const int colortex0Format = RGBA32F;
const int colortex4Format = RGBA32F;
*/

const float sharpness = 0.5f;

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;
    vec3 blurred = texture2D(colortex4, uv).rgb;
    float depth = texture2D(depthtex0, uv).r;

    if (depth < 0.99999f)
        albedo = albedo + (albedo - blurred) * sharpness;
    
    gl_FragColor = vec4(albedo, 1.0f);
}