#version 120

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

void main() {
    gl_Position = ftransform();
    uv.xy = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;;
    uv.zw = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.xy;
    uv.zw = (uv.zw * 33.05f / 32.0f) - (1.05f / 32.0f);
    normal = normalize(gl_NormalMatrix * gl_Normal);
    color = gl_Color;
}