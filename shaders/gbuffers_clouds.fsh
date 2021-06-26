#version 120

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;
uniform float rainStrength;

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;
    albedo = pow(albedo, vec4(2.2));
    albedo.a *= 1 - rainStrength;

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = albedo;
}