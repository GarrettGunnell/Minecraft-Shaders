#version 120

varying vec2 uv;

uniform vec3 sunPosition;

uniform sampler2D colortex0;
uniform sampler2D colortex1;

/*
const int colortex0Format = RGBA16;
const int colortex1Format = RGBA16;
*/

const float sunPathRotation = -40.0f;

const float Ambient = 0.1f;

void main() {
    vec3 albedo = pow(texture2D(colortex0, uv).rgb, vec3(2.2f));
    vec3 normal = normalize(texture2D(colortex1, uv).rgb * 2.0f - 1.0f);
    float ndotl = max(dot(normal, normalize(sunPosition)), 0.0f);

    vec3 diffuse = albedo * (ndotl + Ambient);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(diffuse, 1.0f);
}