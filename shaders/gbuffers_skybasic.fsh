#version 120

uniform vec3 skyColor;
uniform float viewWidth, viewHeight;

uniform mat4 gbufferProjectionInverse;

void main() {
    vec4 clipSpace = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z, 1.0);
	vec4 viewSpace = gbufferProjectionInverse * (clipSpace * 2.0 - 1.0);

    /* DRAWBUFFERS: 0 */
    gl_FragData[0] = vec4(skyColor, 1.0f);
}