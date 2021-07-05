#version 120

varying vec2 uv;
uniform sampler2D colortex0;
uniform sampler2D colortex4;

/*
const int colortex0Format = RGBA32F;
const int colortex4Format = RGBA32F;
*/

void main() {
    vec3 bloomTex = texture2D(colortex4, uv).rgb;

    /* DRAWBUFFERS:4 */
    gl_FragColor = vec4(bloomTex, 1.0f);
    //gl_FragColor = vec4(vec3(mask), 1.0f);
}