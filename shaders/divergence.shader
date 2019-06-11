shader_type canvas_item;

// DIVERGENCE SHADER

uniform float N = 512;

uniform sampler2D velocity_texture;
uniform sampler2D obstacle_texture;

void fragment()
{
	//vec2(1.0, 1.0) - ((tex.xy * 2.0 - 1.0) * float(rest));
	//vec3 tex = texture(velocity_texture, SCREEN_UV).rgb;
	//vec2 velocity = tex.rg * 2.0 - 1.0;
	
	int i = int(SCREEN_UV.x * N);
	int j = int(SCREEN_UV.y * N);
	
	float u1 = texelFetch(velocity_texture, ivec2(i+1, j), 0).x * 2.0 - 1.0;
	float u2 = texelFetch(velocity_texture, ivec2(i-1, j), 0).x * 2.0 - 1.0;
	float v1 = texelFetch(velocity_texture, ivec2(i, j+1), 0).y * 2.0 - 1.0;
	float v2 = texelFetch(velocity_texture, ivec2(i, j-1), 0).y * 2.0 - 1.0;
	
	COLOR.r = (u1 - u2 + v1 - v2);
	COLOR.gb = vec2(0.0);
}