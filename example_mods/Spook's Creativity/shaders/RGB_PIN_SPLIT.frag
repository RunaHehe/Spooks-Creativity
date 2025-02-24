#pragma header

uniform float amount; // 0.05
uniform float distortionFactor; // 0.05

void main() {
	vec2 uv = openfl_TextureCoordv.xy;
	vec2 center = vec2(0.5, 0.5);

	vec2 distortedUV = uv - center;
	float distortion = dot(distortedUV, vec2(1.)) * distortionFactor;

	vec4 col = flixel_texture2D(bitmap, uv);
	col.r = flixel_texture2D(bitmap, uv + amount * distortedUV + distortion / openfl_TextureSize.xy).r;
	col.b = flixel_texture2D(bitmap, uv - amount * distortedUV - distortion / openfl_TextureSize.xy).b;

	gl_FragColor = col;
}