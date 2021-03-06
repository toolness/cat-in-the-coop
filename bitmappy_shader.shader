shader_type spatial;

uniform sampler2D tex;

const float TEX_SIZE = 128.0;

void fragment() {
	float x = UV.x;
	float y = UV.y;
	x = floor(x * TEX_SIZE) / TEX_SIZE;
	y = floor(y * TEX_SIZE) / TEX_SIZE;
	// We have to use textureLod() here, as using texture() somehow
	// causes artifacts to appear.
	ALBEDO = textureLod(tex, vec2(x, y), 0.0).rgb;
}

void light() {
	DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * (ATTENUATION*2.5) * ALBEDO;
}
