#version 120

varying vec2 uv;

uniform sampler2D texture;
uniform float rainStrength;

void main() {
    vec4 albedo = texture2D(texture, uv);
    
    float mask = 0.0f;
    if (albedo.r != albedo.g && albedo.g != albedo.b)
        mask = 1.0f * (1 - rainStrength);

    albedo.a = 1 - rainStrength;

    /* DRAWBUFFERS: 02 */
    gl_FragData[0] = albedo;
}