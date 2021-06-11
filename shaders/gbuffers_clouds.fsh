#version 120

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;
uniform vec3 upPosition;

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;

    /* DRAWBUFFERS:01 */
    gl_FragData[0] = vec4(albedo.rgb, 0.0f);
    gl_FragData[1] = vec4((upPosition + 1.0f) / 2.0f, 1.0f);
}