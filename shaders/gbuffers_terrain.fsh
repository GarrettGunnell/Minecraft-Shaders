#version 120

varying vec2 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;

void main() {
    vec4 albedo = texture2D(texture, uv) * color;

    /* DRAWBUFFERS:01 */
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(normal * 0.5f + 0.5f, 1.0f);
}