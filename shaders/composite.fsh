#version 120

varying vec2 uv;
uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;

uniform float near, far;
uniform float rainStrength;

#define FOG_DENSITY 0.008
#define RAIN_MODIFIER 0.011

/*
const int colortex0Format = RGBA16;
*/

float LinearDepth(float z) {
    return 1.0 / ((1 - far / near) * z + (far / near));
}

float FogExp(float viewDistance, float density) {
    float factor = viewDistance * (density / log(2.0f));
    return exp2(-factor);
}

float FogExp2(float viewDistance, float density) {
    float factor = viewDistance * (density / sqrt(log(2.0f)));
    return exp2(-factor * factor);
}

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo = pow(albedo, vec3(1 / 2.2));
    
    float mask = 1 - texture2D(colortex2, uv).r;
    float depth = texture2D(depthtex0, uv).r;

    depth = LinearDepth(depth);
    float viewDistance = depth * far - near;

    float density = FOG_DENSITY + (RAIN_MODIFIER * rainStrength);

    if (depth > 0.9999f && rainStrength < 0.99f)
        density *= 0.5f;

    float fogFactor1 = FogExp(viewDistance, density);
    float fogFactor2 = FogExp2(viewDistance, density);
    
    float fogFactor = 1 - clamp(mix(fogFactor1, fogFactor2, rainStrength), 0.0f, 1.0f);
    fogFactor *= mask;

    vec3 fogColor = vec3(0.82f, 0.83f, 0.9f);
    fogColor *= mix(1.0, 0.25, rainStrength);
    vec3 fogged = mix(albedo, fogColor, fogFactor);

    fogged = pow(fogged, vec3(2.2));

    gl_FragColor = vec4(fogged, 1.0f);
    //gl_FragColor = vec4(vec3(mask), 1.0f);
}