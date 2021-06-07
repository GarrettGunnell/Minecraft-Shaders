#version 120

varying vec2 uv;

uniform sampler2D texture;

void main() {
    vec4 albedo = texture2D(texture, uv);

    /* DRAWBUFFERS: 0 */
    gl_FragData[0] = albedo;
}