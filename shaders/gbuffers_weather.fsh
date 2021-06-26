#version 120

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;
    albedo.rgb = pow(albedo.rgb, vec3(2.2));

    /* DRAWBUFFERS:02 */
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(vec3(1.0f), 1.0f); // fog mask
}