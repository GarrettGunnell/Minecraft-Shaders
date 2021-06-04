#version 120

varying vec2 uv;
uniform sampler2D colortex0;

void main() {
    vec3 Color = texture2D(colortex0, uv).rgb;

    gl_FragColor = vec4(Color, 1.0f);
}