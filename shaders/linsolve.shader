shader_type canvas_item;

// LINSOLVE

uniform float N = 512;
uniform float A = 0.0;
uniform float C = 0.0;

uniform int MAX_ITER = 20;

vec3 lin_solve(float n, sampler2D x0, vec2 screen_uv, float a, float c)
{
	vec3 result = vec3(0.0, 0.0, 0.0);
	int i = int(screen_uv.x * n);
	int j = int(screen_uv.y * n);
	for(int iter = 0; iter < MAX_ITER; iter++) {
		vec3 c0 = texelFetch(x0, ivec2(i, j), 0).rgb;
		vec3 c1 = texelFetch(x0, ivec2(i-1, j), 0).rgb;
		vec3 c2 = texelFetch(x0, ivec2(i+1, j), 0).rgb;
		vec3 c3 = texelFetch(x0, ivec2(i, j-1), 0).rgb;
		vec3 c4 = texelFetch(x0, ivec2(i, j+1), 0).rgb;
		vec3 t = (c0 + a * (c1 + c2 + c3 + c4)) / c;
		result += t;
	}
	return result;
}

void fragment()
{
	COLOR.rgb = lin_solve(N, SCREEN_TEXTURE, SCREEN_UV, A, C);
}