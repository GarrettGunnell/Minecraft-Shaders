#version 120
#include "distort.glsl"

varying vec2 uv;
varying vec4 color;

void main() {
    gl_Position = ftransform();
    gl_Position.xy = DistortPosition(gl_Position.xy);
    uv = gl_MultiTexCoord0.xy;
    color = gl_Color;
}