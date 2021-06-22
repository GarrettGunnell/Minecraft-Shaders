#version 120

uniform vec3 skyColor;
uniform vec3 upPosition;
uniform vec3 sunPosition;
uniform float viewWidth, viewHeight;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

void main() {
    vec3 sunDirection = mat3(gbufferModelViewInverse) * (sunPosition * 0.01);
    vec4 clipSpace = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z, 1.0f);
	vec4 viewW = gbufferProjectionInverse * (clipSpace * 2.0 - 1.0);
    viewW /= viewW.w;

    vec3 viewSpace = normalize(viewW.xyz) / 20;


    float vdotu = clamp(dot(viewSpace.xyz, upPosition), 0.0f, 1.0f);
    float vdotl = clamp(dot(viewSpace.xyz, sunDirection), -1.0f, 1.0f);

    //vec3 baseGradient = skyColor * exp(-(1.0 - pow(1.0 - max(vdotu, 0.0), 1.5 - 0.5 * vdotl)) / 1.0f);

    vec3 topGradient = vec3(0.48f, 0.76f, 0.85f);
    vec3 bottomGradient = vec3(0.82f, 0.83f, 0.9f);
    vec3 skyCol = mix(bottomGradient, topGradient, vdotu);

    skyCol = pow(skyCol, vec3(2.2));

    /* DRAWBUFFERS: 0 */
    gl_FragData[0] = vec4(skyCol, 1.0f);
}