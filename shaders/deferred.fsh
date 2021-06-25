#version 120

varying vec2 uv;
uniform sampler2D colortex0;

/*
const int colortex0Format = RGBA16;
*/

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;

    gl_FragColor = vec4(albedo, 1.0f);
}