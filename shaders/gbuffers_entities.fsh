#version 120

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;

    /* DRAWBUFFERS:012 */
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4((normal + 1.0f) / 2.0f, 1.0f);
    gl_FragData[2] = vec4(uv.zw, 0.0f, 1.0f);
}