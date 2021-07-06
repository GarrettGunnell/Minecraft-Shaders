#version 120
#include "common.glsl"

varying vec2 uv;
uniform sampler2D colortex0;
uniform sampler2D colortex4;

uniform float rainStrength;
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
        col += gauss * texture2D(colortex0, uv + vec2(texelSize.x * x, 0.0)).rgb;
    }

    for (int y = lower; y <= upper; ++y) {
        float gauss = gaussian(y);
        kernelSum += gauss;
        col += gauss * texture2D(colortex0, uv + vec2(0.0, texelSize.y * y)).rgb;
    }

    col /= kernelSum;

    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo += col.rgb * mix(0.5, 0.7, luminance(col)) * (1 - rainStrength);

    /* DRAWBUFFERS:0 */
    gl_FragColor = vec4(albedo, 1.0f);
    //gl_FragColor = vec4(col, 1.0f);
}