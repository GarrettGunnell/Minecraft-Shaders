#version 120
#include "common.glsl"

varying vec2 uv;
uniform sampler2D colortex0;

/*
const int colortex0Format = RGBA32F;
*/

const float saturation = 1.5f;

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;

    vec3 desaturated = vec3(luminance(albedo));

    albedo = mix(desaturated, albedo, saturation);

    gl_FragColor = vec4(albedo, 1.0f);
}