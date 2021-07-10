#version 120

#include "settings.glsl"
#include "common.glsl"
#include "lighting.glsl"

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;
    albedo = pow(albedo, vec4(2.2));
    vec3 newNormal = normalize(normal);
    vec3 diffuse = CalculateLighting(albedo.rgb, newNormal, uv.zw, gl_FragCoord.xyz);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(diffuse, albedo.a);
    //gl_FragData[0] = vec4(lightmap.rg, 0, 0);
}