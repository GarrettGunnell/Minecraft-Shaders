#version 120
#include "common.glsl"

varying vec2 uv;
uniform sampler2D colortex0;

uniform float viewWidth, viewHeight;
vec2 texelSize = vec2(1.0 / viewWidth, 1.0 / viewHeight);

/*
const int colortex0Format = RGBA32F;
*/

#define TWO_PI 6.28319
#define E 2.71828

float gaussian(int x, int y) {
    float sigmaSqu = 3.0 * 3.0;
    return (1 / sqrt(TWO_PI * sigmaSqu)) * pow(E, -((x * x) + (y* y)) / (2 * sigmaSqu));
}

void main() {
    vec4 result = vec4(0.0);
    float kernelSum = 0.0f;

    for (int x = -3; x <= 3; ++x) {
        for (int y = -3; y <= 3; ++y) {
            vec2 offset = vec2(x, y) * texelSize.xy;
            float gauss = gaussian(x, y);
            kernelSum += gauss;
            result += texture2D(colortex0, uv + offset.xy) * gauss;
        }
    }

    result /= kernelSum;

    /* DRAWBUFFERS:4 */
    gl_FragColor = result;
}