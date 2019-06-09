shader_type canvas_item;

// BOUNDS SHADER

uniform sampler2D bounds;

void fragment()
{
	float density = texture(SCREEN_TEXTURE, UV).r;
	bool block = texture(bounds, UV).r > 0.0;
	if(block)
	{
		COLOR.rgb = vec3(0.0);
	} else {
		COLOR.rgb = vec3(density, 1, 1);
	}
}