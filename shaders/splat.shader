shader_type canvas_item;

// SPLAT DENSITY SHADER

uniform vec3 force;
uniform int brush_form = 0;
uniform int brush_mode = 0;

uniform vec2 point;
uniform float radius;

float gauss(vec2 p, float r)
{
    return exp(-dot(p, p) / r);
}

float rect(vec2 p, float r) {
	if(r <= 0.0)return 0.0;
	
	vec2 bl = step(vec2(0.1), p + max(r, 1.0)); // bottom-left
	vec2 tr = step(vec2(0.1), max(r, 1.0) - p); // top-right
	return (bl.x * bl.y * tr.x * tr.y);
}

void fragment()
{
    vec3 base = texture(SCREEN_TEXTURE, UV).rgb;
    vec2 coord = point * SCREEN_PIXEL_SIZE - UV;
	vec2 tcoord = coord / SCREEN_PIXEL_SIZE;
	float splat = 0.0;
	if (brush_form == 0) {
    	splat = gauss(tcoord, radius);
	} else {
		splat = rect(tcoord, radius / 8.0);
	}
	if(brush_mode == 1) {
		COLOR.rgb = mix(base, vec3(0, 0, 0), splat).rgb;
	} else {
		COLOR.rgb = mix(base, force, splat).rgb;
	}
}