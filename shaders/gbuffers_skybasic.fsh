#version 120

uniform vec3 skyColor;

void main() {
    /* DRAWBUFFERS: 0 */
    gl_FragData[0] = vec4(skyColor, 1.0f);
}