float luminance(vec3 color) {
    return dot(color, vec3(0.2125f, 0.7153f, 0.0721f));
}

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}