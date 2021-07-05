#version 120
#include "common.glsl"

varying vec2 uv;
uniform sampler2D colortex0;

/*
const int colortex0Format = RGBA32F;
*/

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo = pow(albedo, vec3(1.0f / 2.2f));

    gl_FragColor = vec4(albedo, 1.0f);
}