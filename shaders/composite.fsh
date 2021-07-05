#version 120
#include "common.glsl"

varying vec2 uv;
uniform sampler2D colortex0;

/*
const int colortex0Format = RGBA32F;
*/

const float contrast = 0.85;
const float brightness = 0.02;

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo = pow(albedo, vec3(1.0f / 2.2f));

    albedo = contrast * (albedo - 0.5) + 0.5 + brightness;

    gl_FragColor = vec4(albedo, 1.0f);
}