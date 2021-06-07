#version 120

varying vec2 uv;

uniform sampler2D texture;

void main() {
    vec4 albedo = texture2D(texture, uv);

    /* DRAWBUFFERS: 4 */
    gl_FragData[4] = albedo;
}