shader_type canvas_item;

uniform sampler2D velocity;

// ADVECT DENSITY

void fragment()
{
	COLOR.rgb = mix(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, vec3(0.0, 0.0, 0.0), 0.1);
}