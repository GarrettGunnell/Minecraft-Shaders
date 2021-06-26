#version 120

varying vec2 uv;

uniform sampler2D texture;
uniform float rainStrength;

void main() {
    vec4 albedo = texture2D(texture, uv);
    albedo = pow(albedo, vec4(2.2));
    
    if (albedo.r != albedo.g && albedo.g != albedo.b)
        albedo.rgb += 0.2;

    albedo.a = 1 - rainStrength;

    /* DRAWBUFFERS: 0 */
    gl_FragData[0] = albedo;
}