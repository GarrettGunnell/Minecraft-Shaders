#version 120

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;

uniform vec3 skyColor;
uniform vec3 sunPosition;

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;
    albedo = pow(albedo, vec4(2.2));

    vec2 lightmap = uv.zw;
    vec3 torchColor = vec3(1.0f);
    vec3 torchLight = lightmap.x * torchColor;
    vec3 skyLight = lightmap.y * skyColor;

    vec3 lightColor = torchLight + skyLight;

    vec3 sunDirection = normalize(sunPosition);
    float ndotl = clamp(dot(normal, sunDirection), 0.0f, 1.0f);

    vec3 lighting = lightColor + ndotl;

    vec3 diffuse = albedo.rgb * lighting;

    /* DRAWBUFFERS:012 */
    gl_FragData[0] = vec4(diffuse, albedo.a);
    gl_FragData[1] = vec4((normal + 1.0f) / 2.0f, 1.0f);
    gl_FragData[2] = vec4(uv.zw, 0.0f, 1.0f);
}