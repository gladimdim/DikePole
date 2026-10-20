shader_type canvas_item;
render_mode unshaded;

uniform vec4 paper_color : source_color = vec4(0.92, 0.86, 0.73, 1.0);
uniform float grain_strength = 0.065;

float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
		mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0)), f.x), f.y);
}

void fragment() {
	vec2 pixel = SCREEN_UV / SCREEN_PIXEL_SIZE;
	float grain = hash(floor(pixel)) - 0.5;
	float clouds = noise(SCREEN_UV * vec2(7.0, 11.0)) - 0.5;
	float fibers = noise(pixel * vec2(0.45, 0.08)) - 0.5;
	float edge = pow(abs(SCREEN_UV.x - 0.5) * 2.0, 6.0);
	float age = grain * 0.30 + clouds * 0.50 + fibers * 0.20 - edge * 0.7;
	COLOR = vec4(paper_color.rgb + age * grain_strength, 1.0);
}
