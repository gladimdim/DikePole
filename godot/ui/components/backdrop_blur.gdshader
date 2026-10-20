// Flutter BackdropFilter(ImageFilter.blur(sigma)) + Colors.black.withOpacity(0.2) scrim.
shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
// Blur sigma in screen pixels (logical sigma × content scale).
uniform float sigma = 1.5;
uniform vec4 tint : source_color = vec4(0.0, 0.0, 0.0, 0.2);

void fragment() {
	vec3 sum = vec3(0.0);
	float total = 0.0;
	for (int x = -3; x <= 3; x++) {
		for (int y = -3; y <= 3; y++) {
			vec2 offset = vec2(float(x), float(y)) * sigma * 0.75;
			float w = exp(-dot(offset, offset) / (2.0 * sigma * sigma));
			sum += texture(screen_tex, SCREEN_UV + offset * SCREEN_PIXEL_SIZE).rgb * w;
			total += w;
		}
	}
	COLOR = vec4(mix(sum / total, tint.rgb, tint.a), 1.0);
}
