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
    vec3 albedo = texture2D(colortex0, uv).rgb;
    albedo = pow(albedo, vec3(2.2f)); // gamma correct

    vec3 normal = texture2D(colortex1, uv).rgb;
    normal = normal * 2.0f - 1.0f; // unpack normal

    float ndotl = max(dot(normal, normalize(sunPosition)), 0.0f);

    vec3 diffuse = albedo * (ndotl + Ambient);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(pow(diffuse, vec3(1.0f / 2.2f)), 1.0f);
}