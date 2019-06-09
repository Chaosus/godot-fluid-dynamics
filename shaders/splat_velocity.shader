shader_type canvas_item;

// SPLAT VELOCITY SHADER

uniform vec4 color : hint_color;
uniform vec2 point;
uniform float radius;

float gauss(vec2 p, float r)
{
    return exp(-dot(p, p) / r);
}

void fragment()
{
    vec3 base = texture(SCREEN_TEXTURE, UV).rgb;
    vec2 coord = point * SCREEN_PIXEL_SIZE - UV;
	vec2 tcoord = coord / SCREEN_PIXEL_SIZE;
    float splat = gauss(tcoord, radius);
    COLOR.rg = mix(base, color.rgb, splat).rg;
	COLOR.b = 1.0;
}