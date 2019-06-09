shader_type canvas_item;

uniform float N = 512;
uniform sampler2D divergence_texture;

// PROJECT SHADER

void fragment()
{
	vec3 uv = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	int i = int(SCREEN_UV.x * N);
	int j = int(SCREEN_UV.y * N);
	
	float p1 = texelFetch(divergence_texture, ivec2(i+1, j), 0).r;
	float p2 = texelFetch(divergence_texture, ivec2(i-1, j), 0).r;
	float p3 = texelFetch(divergence_texture, ivec2(i, j+1), 0).r;
	float p4 = texelFetch(divergence_texture, ivec2(i, j-1), 0).r;
	
	uv.x -= 0.5 * N * (p1 - p2);
	uv.y -= 0.5 * N * (p3 - p4);
	
	COLOR.rgb = uv;
}