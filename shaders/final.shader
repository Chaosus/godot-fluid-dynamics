shader_type canvas_item;

uniform sampler2D density_texture;

void fragment()
{
	COLOR.r = texture(density_texture, SCREEN_UV).r;
}