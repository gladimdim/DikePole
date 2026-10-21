// Story picture: reveal transition + Ken Burns view + ambient overlay.
// Driven by anim/story_image.gd; see art/STYLE_GUIDE.md section 8 for the metadata.
shader_type canvas_item;

const int REVEAL_FADE = 0;
const int REVEAL_SKETCH = 1;
const int REVEAL_DEVELOP = 2;
const int REVEAL_INK = 3;

const int AMBIENT_FIRE = 1;
const int AMBIENT_MIST = 2;
const int AMBIENT_WATER = 3;
const int AMBIENT_WIND = 4;
const int AMBIENT_RAIN = 5;
const int AMBIENT_SNOW = 6;
const int AMBIENT_SMOKE = 7;
const int AMBIENT_DUST = 8;
const int AMBIENT_NIGHT = 9;

uniform sampler2D to_tex : source_color, filter_linear, repeat_disable;
uniform sampler2D from_tex : source_color, filter_linear, repeat_disable;
uniform bool has_from = false;
// Maps the drawn rect (UV 0..1) onto each texture: uv = map.xy + view * map.zw.
uniform vec4 to_map = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 from_map = vec4(0.0, 0.0, 1.0, 1.0);
uniform int reveal = 0;
// Flutter TweenImage: two stacked Opacity widgets (1 - v and v) over the background.
uniform bool classic = false;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 background : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 paper : source_color = vec4(0.93, 0.91, 0.86, 1.0);
uniform vec2 view_center = vec2(0.5);
uniform float view_zoom = 1.0;
uniform int ambient = 0;
uniform vec4 ambient_region = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec2 rect_size = vec2(400.0, 300.0);
uniform float corner_radius = 0.0;
// Darkens the lower part so text over the picture stays readable.
uniform float bottom_shade = 0.0;

float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
			mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
	float value = 0.0;
	float amplitude = 0.5;
	for (int i = 0; i < 4; i++) {
		value += amplitude * noise(p);
		p *= 2.03;
		amplitude *= 0.5;
	}
	return value;
}

float lum(vec3 c) {
	return dot(c, vec3(0.299, 0.587, 0.114));
}

vec4 sample_mapped(sampler2D tex, vec4 map, vec2 view) {
	vec2 uv = map.xy + view * map.zw;
	if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
		return vec4(0.0);
	}
	return texture(tex, uv);
}

// Soft 0..1 mask of the ambient region (in image space).
float region_mask(vec2 view) {
	vec2 lo = ambient_region.xy;
	vec2 hi = ambient_region.xy + ambient_region.zw;
	vec2 edge = vec2(0.06);
	vec2 m = smoothstep(lo - edge, lo + edge, view) * (1.0 - smoothstep(hi - edge, hi + edge, view));
	return m.x * m.y;
}

// Pencil drawing made from the photo: colour-dodge of the blurred inverse, cross
// hatching in the shadows and paper grain. Stands in for the hand-made sketches.
vec3 pencil(vec2 view, vec2 frame_uv) {
	float g = lum(sample_mapped(to_tex, to_map, view).rgb);
	vec2 px = 1.0 / rect_size;
	float blur = 0.0;
	for (int i = 0; i < 12; i++) {
		float a = float(i) * 0.5235988;
		vec2 o = vec2(cos(a), sin(a)) * px;
		blur += lum(sample_mapped(to_tex, to_map, view + o * 1.5).rgb);
		blur += lum(sample_mapped(to_tex, to_map, view + o * 3.5).rgb);
	}
	blur /= 24.0;
	float dodge = pow(clamp(g / max(blur, 0.02), 0.0, 1.0), 3.0);
	vec2 p = frame_uv * rect_size;
	float dark = 1.0 - g;
	float h1 = smoothstep(0.7, 1.0, abs(fract((p.x + p.y) / 4.0) - 0.5) * 2.0) * smoothstep(0.35, 0.75, dark);
	float h2 = smoothstep(0.7, 1.0, abs(fract((p.x - p.y) / 5.0) - 0.5) * 2.0) * smoothstep(0.6, 0.95, dark);
	float shade = dodge * (1.0 - 0.45 * (h1 + h2)) * mix(0.75, 1.0, smoothstep(0.0, 0.5, g));
	shade -= (noise(p * 0.9) - 0.5) * 0.07;
	float border = min(min(frame_uv.x, 1.0 - frame_uv.x), min(frame_uv.y, 1.0 - frame_uv.y));
	float vignette = smoothstep(0.0, 0.07, border + (noise(p * 0.05) - 0.5) * 0.04);
	vec3 graphite = vec3(0.18, 0.18, 0.2);
	return mix(paper.rgb, mix(graphite, paper.rgb, clamp(shade, 0.0, 1.0)), vignette);
}

vec2 ambient_distort(vec2 view) {
	if (ambient == AMBIENT_WATER) {
		float m = region_mask(view);
		view.x += sin(view.y * 140.0 + TIME * 2.2) * 0.0012 * m;
		view.y += sin(view.x * 90.0 + TIME * 1.7) * 0.0009 * m;
	} else if (ambient == AMBIENT_WIND) {
		float m = region_mask(view);
		float top = 1.0 - clamp((view.y - ambient_region.y) / max(ambient_region.w, 0.001), 0.0, 1.0);
		view.x += sin(TIME * 1.6 + view.y * 22.0 + view.x * 9.0) * 0.0022 * m * top;
	}
	return view;
}

vec3 ambient_overlay(vec3 col, vec2 view) {
	float m = region_mask(view);
	vec2 p = view * rect_size;
	if (ambient == AMBIENT_FIRE) {
		float f = 0.5 + 0.5 * sin(TIME * 7.3) * sin(TIME * 3.1 + 1.3) + 0.25 * (noise(vec2(TIME * 4.0, 0.0)) - 0.5);
		col *= 1.0 + m * (0.04 + 0.08 * f) * vec3(1.0, 0.72, 0.42);
	} else if (ambient == AMBIENT_MIST) {
		float n = fbm(view * vec2(3.0, 7.0) + vec2(TIME * 0.025, TIME * 0.004));
		col = mix(col, vec3(0.86, 0.88, 0.9), m * smoothstep(0.4, 0.85, n) * 0.38);
	} else if (ambient == AMBIENT_WATER) {
		float s = noise(p * vec2(0.08, 0.5) + vec2(TIME * 0.6, 0.0));
		col += m * smoothstep(0.82, 1.0, s) * 0.08;
	} else if (ambient == AMBIENT_RAIN) {
		vec2 q = vec2(p.x + p.y * 0.18, p.y + TIME * 700.0);
		float drop = step(0.97, hash(floor(vec2(q.x / 2.5, q.y / 28.0))));
		col = mix(col * 0.92, vec3(0.82, 0.85, 0.9), drop * 0.3 * m);
	} else if (ambient == AMBIENT_SNOW) {
		float flakes = 0.0;
		for (int layer = 0; layer < 2; layer++) {
			float size = 18.0 + float(layer) * 12.0;
			vec2 q = p / size + vec2(sin(TIME * 0.5 + float(layer)) * 0.4, -TIME * (0.6 + 0.3 * float(layer)));
			vec2 cell = floor(q);
			vec2 centre = vec2(hash(cell), hash(cell + 7.1));
			flakes += smoothstep(0.09, 0.0, length(fract(q) - centre)) * step(0.55, hash(cell + 3.3));
		}
		col = mix(col, vec3(0.97), clamp(flakes, 0.0, 1.0) * 0.85 * m);
	} else if (ambient == AMBIENT_SMOKE) {
		float n = fbm(view * vec2(2.5, 3.5) + vec2(TIME * 0.01, -TIME * 0.05));
		col = mix(col, vec3(0.55, 0.53, 0.5), m * smoothstep(0.45, 0.9, n) * 0.45);
	} else if (ambient == AMBIENT_DUST) {
		vec2 q = p / 26.0 + vec2(TIME * 0.12, sin(TIME * 0.3) * 0.3);
		vec2 cell = floor(q);
		vec2 centre = vec2(hash(cell), hash(cell + 2.7));
		float mote = smoothstep(0.06, 0.0, length(fract(q) - centre)) * step(0.7, hash(cell + 9.1));
		col += mote * 0.35 * m * (0.6 + 0.4 * sin(TIME * 2.0 + hash(cell) * 6.28));
	} else if (ambient == AMBIENT_NIGHT) {
		col *= mix(1.0, 0.94 + 0.05 * sin(TIME * 0.6), m);
		col = mix(col, col * vec3(0.86, 0.92, 1.08), 0.35 * m);
	}
	return col;
}

void fragment() {
	vec2 view = view_center + (UV - 0.5) / view_zoom;
	view = ambient_distort(view);

	vec4 to_c = sample_mapped(to_tex, to_map, view);
	vec4 from_c;
	if (has_from) {
		from_c = sample_mapped(from_tex, from_map, view);
	} else if (reveal == REVEAL_SKETCH && progress < 1.0) {
		from_c = vec4(pencil(view, UV), 1.0);
	} else if (reveal == REVEAL_DEVELOP || reveal == REVEAL_INK) {
		from_c = paper;
	} else {
		from_c = background;
	}

	vec4 col;
	if (classic) {
		vec3 under = mix(background.rgb, from_c.rgb, from_c.a * (1.0 - progress));
		col = vec4(mix(under, to_c.rgb, to_c.a * progress), max(from_c.a, to_c.a) > 0.0 ? 1.0 : 0.0);
	} else if (reveal == REVEAL_SKETCH) {
		float n = fbm(UV * vec2(3.0, 2.2));
		float m = smoothstep(n - 0.25, n + 0.25, progress * 1.5 - 0.25);
		col = mix(from_c, to_c, m);
	} else if (reveal == REVEAL_DEVELOP) {
		float l = lum(to_c.rgb);
		float d = clamp(progress * 1.4 - l * 0.4, 0.0, 1.0);
		vec3 sepia = vec3(l) * vec3(1.07, 0.95, 0.78);
		vec3 developing = mix(paper.rgb, sepia, smoothstep(0.0, 0.6, d));
		col = vec4(mix(developing, to_c.rgb, smoothstep(0.45, 1.0, d)), to_c.a);
	} else if (reveal == REVEAL_INK) {
		float n = fbm(UV * vec2(4.0, 3.0));
		float t = progress * 1.3 - 0.15;
		float m = smoothstep(n - 0.04, n + 0.04, t);
		float edge = clamp(smoothstep(n - 0.12, n, t) - m, 0.0, 1.0);
		col = mix(from_c, to_c, m);
		col.rgb *= 1.0 - edge * 0.65;
	} else {
		col = mix(from_c, to_c, progress);
	}

	if (ambient > 0) {
		col.rgb = ambient_overlay(col.rgb, view);
	}

	col.rgb *= 1.0 - bottom_shade * smoothstep(0.3, 1.0, UV.y);

	if (corner_radius > 0.0) {
		vec2 p = UV * rect_size;
		vec2 q = abs(p - rect_size * 0.5) - (rect_size * 0.5 - vec2(corner_radius));
		float d = length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - corner_radius;
		col.a *= clamp(0.5 - d, 0.0, 1.0);
	}
	COLOR = col;
}
