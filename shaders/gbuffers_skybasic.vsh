#version 120

varying float star;

void main() {
    gl_Position = ftransform();

    star = float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0);
}