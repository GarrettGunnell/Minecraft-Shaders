#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0;

void main() {
    vec3 Color = texture2D(colortex0, TexCoords).rgb;

    Color.rgb = Color.rbg;

    gl_FragColor = vec4(Color, 1.0f);
}