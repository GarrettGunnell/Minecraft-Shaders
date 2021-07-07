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
const int colortex0Format = RGBA32F;
const int colortex2Format = R8;
*/

float LinearDepth(float z) {
    return 1.0 / ((1 - far / near) * z + (far / near));
}

float FogExp2(float viewDistance, float density) {
    float factor = viewDistance * (density / sqrt(log(2.0f)));
    return exp2(-factor * factor);
}

const float contrast = 1.25f;
const float brightness = 0.25f;

void main() {
    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo = pow(albedo, vec3(1.0f / 2.2f));

    float mask = 1 - texture2D(colortex2, uv).r;
    float depth = texture2D(depthtex0, uv).r;

    float density = FOG_DENSITY;

    depth = LinearDepth(depth);
    float viewDistance = depth * far - near;

    vec3 lessContrast = contrast * 0.33 * (albedo - 0.5) + 0.5 + brightness;
    albedo = contrast * (albedo - 0.5) + 0.5 + brightness;

    float contrastFactor = 1 - clamp(FogExp2(viewDistance, density), 0.0f, 1.0f);
    contrastFactor *= mask;

    if (depth < 0.99999f)
        albedo = mix(albedo, lessContrast, contrastFactor);


    gl_FragColor = vec4(albedo, 1.0f);
}