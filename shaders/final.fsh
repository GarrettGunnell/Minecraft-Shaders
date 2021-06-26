#version 120

varying vec2 uv;
uniform sampler2D colortex0;

/*
const int colortex0Format = RGBA32F;
*/

void main() {
    vec3 Color = pow(texture2D(colortex0, uv).rgb, vec3(1.0f / 2.2f));

    gl_FragColor = vec4(Color, 1.0f);
}