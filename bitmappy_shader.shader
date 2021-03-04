shader_type spatial;

uniform sampler2D tex;

void fragment() {
	float x = UV.x;
	float y = UV.y;
	x = floor(x * 512.0) / 512.0;
	y = floor(y * 512.0) / 512.0;
	ALBEDO = texture(tex, vec2(x, y)).rgb;
}

void light() {
	DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * ALBEDO;
	SPECULAR_LIGHT = vec3(0.0, 0.0, 0.0);
}
