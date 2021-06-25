#version 120

varying vec2 uv;
uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform float near, far;

#define FOG_DENSITY 0.01
const vec3 fogColor = vec3(0.82f, 0.83f, 0.9f);

/*
const int colortex0Format = RGBA16;
*/

float LinearDepth(float z) {
    return 1.0 / ((1 - far / near) * z + (far / near));
}

float FogExp(float viewDistance) {
    float factor = viewDistance * (FOG_DENSITY / log(2.0f));
    return exp2(-factor);
}

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo = pow(albedo, vec3(1 / 2.2));
    float depth = texture2D(depthtex0, uv).r;

    depth = LinearDepth(depth);

    float viewDistance = depth * far - near;
    float fogFactor = depth > 0.99999f ? 1.0f : FogExp(viewDistance);
    fogFactor = clamp(fogFactor, 0.0f, 1.0f);
    vec3 fogged = mix(fogColor, albedo, fogFactor);

    fogged = pow(fogged, vec3(2.2));

    gl_FragColor = vec4(fogged, 1.0f);
    //gl_FragColor = vec4(albedo, 1.0f);
}