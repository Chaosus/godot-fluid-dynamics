shader_type canvas_item;

uniform sampler2D density;

// ADVECT VELOCITY

void fragment()
{
    COLOR.rg = texture(SCREEN_TEXTURE, SCREEN_UV).rg + 0.5;
}