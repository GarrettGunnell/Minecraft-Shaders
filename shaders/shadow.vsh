#version 120
#include "distort.glsl"

void main() {
    gl_Position = ftransform();
    gl_Position.xy = DistortPosition(gl_Position.xy);
}