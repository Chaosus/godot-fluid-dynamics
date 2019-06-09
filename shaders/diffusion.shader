shader_type canvas_item;

// DIFFUSION SHADER

uniform float N = 512;
uniform int max_iterations = 20;
uniform float diff = 0.5;
uniform float dt = 0.0001;

vec3 lin_solve(sampler2D surface, vec2 ij, float a, float c)
{
	vec3 result = vec3(0.0, 0.0, 0.0);
	int i = int(ij.x * N);
	int j = int(ij.y * N);
	for(int iter = 0; iter < max_iterations; iter++) {
		vec3 c0 = texelFetch(surface, ivec2(i, j), 0).rgb;
		vec3 c1 = texelFetch(surface, ivec2(i-1, j), 0).rgb;
		vec3 c2 = texelFetch(surface, ivec2(i+1, j), 0).rgb;
		vec3 c3 = texelFetch(surface, ivec2(i, j-1), 0).rgb;
		vec3 c4 = texelFetch(surface, ivec2(i, j+1), 0).rgb;
		vec3 t = (c0 +  a * (c1 + c2 + c3 + c4)) / c;
		result += t;
	}
	return result;
}

void fragment()
{
	float a = dt*diff*N*N;
	COLOR.rgb = lin_solve(SCREEN_TEXTURE, SCREEN_UV, a, 80.0 * a);
}