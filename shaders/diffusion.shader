shader_type canvas_item;

// DIFFUSION SHADER

uniform sampler2D obstacle_texture;

uniform float viscocity = 0.0;

vec3 lin_solve(float n, sampler2D surface, vec2 coord, highp float a, highp float c)
{
	int i = int(coord.x * n);
	int j = int(coord.y * n);
	
	vec3 result = vec3(0.0, 0.0, 0.0);
	
	vec3 x0 = texelFetch(surface, ivec2(i, j), 0).rgb;
	vec3 x1 = texelFetch(surface, ivec2(i-1, j), 0).rgb;
	vec3 x2 = texelFetch(surface, ivec2(i+1, j), 0).rgb;
	vec3 x3 = texelFetch(surface, ivec2(i, j-1), 0).rgb;
	vec3 x4 = texelFetch(surface, ivec2(i, j+1), 0).rgb;
	
	result += (x0 + a * (x1 + x2 + x3 + x4)) / c;
	
	return result;
}

void fragment()
{
	float n = 512.0;
	float dt = 0.0166666666666667;
	float a = dt * viscocity * n * n;
	COLOR.rgb = lin_solve(n, SCREEN_TEXTURE, SCREEN_UV, a, 1.0 + 4.0 * a);
}