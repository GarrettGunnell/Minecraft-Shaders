#version 120
#include "common.glsl"

varying vec2 uv;
uniform sampler2D colortex0;
uniform sampler2D colortex4;

uniform float viewWidth, viewHeight;
vec2 texelSize = vec2(1.0 / viewWidth, 1.0 / viewHeight);

/*
const int colortex0Format = RGBA32F;
*/

#define KERNEL_SIZE 16
#define SPREAD 5.0

const float TWO_PI = 6.28319;
const float E = 2.71828;

float gaussian(int x) {
    float sigmaSqu = SPREAD * SPREAD;
    return (1 / sqrt(TWO_PI * sigmaSqu)) * pow(E, -(x * x) / (2 * sigmaSqu));
}

void main() {
    vec3 col;

    int upper = ((KERNEL_SIZE - 1) / 2);
    int lower = -upper;

    float kernelSum = 0.0;

    for (int x = lower; x <= upper; ++x) {
        float gauss = gaussian(x);
        kernelSum += gauss;
        vec3 texSample = texture2D(colortex0, uv + vec2(texelSize.x * x, 0.0)).rgb;
        col += gauss * texSample;
    }

    for (int y = lower; y <= upper; ++y) {
        float gauss = gaussian(y);
        kernelSum += gauss;
        vec3 texSample = texture2D(colortex0, uv + vec2(0.0, texelSize.y * y)).rgb;
        col += gauss * texSample;
    }

    col /= kernelSum;

    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo = pow(albedo, vec3(1.0f / 2.2f));
    albedo += col.rgb * 0.5;
    albedo = pow(albedo, vec3(2.2f));

    /* DRAWBUFFERS:0 */
    gl_FragColor = vec4(albedo, 1.0f);
    //gl_FragColor = vec4(col, 1.0f);
}