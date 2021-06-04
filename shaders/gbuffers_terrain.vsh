#version 120

varying vec2 uv;
varying vec3 normal;
varying vec4 color;

void main() {
    gl_Position = ftransform();
    uv = gl_MultiTexCoord0.xy;
    normal = gl_NormalMatrix * gl_Normal;
    color = gl_Color;
}