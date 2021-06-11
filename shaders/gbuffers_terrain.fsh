#version 120

varying vec4 uv;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;

uniform vec3 skyColor;

void main() {
    vec4 albedo = texture2D(texture, uv.xy) * color;
    albedo = pow(albedo, vec4(2.2));

    vec2 lightmap = uv.zw;
    vec3 torchColor = vec3(1.0f);
    vec3 torchLight = lightmap.x * torchColor;
    vec3 skyLight = lightmap.y * skyColor;

    vec3 lightColor = torchLight + skyLight;

    vec4 diffuse = albedo * vec4(lightColor, 1.0f);

    /* DRAWBUFFERS:012 */
    gl_FragData[0] = diffuse;
    gl_FragData[1] = vec4((normal + 1.0f) / 2.0f, 1.0f);
    gl_FragData[2] = vec4(uv.zw, 0.0f, 1.0f);
}