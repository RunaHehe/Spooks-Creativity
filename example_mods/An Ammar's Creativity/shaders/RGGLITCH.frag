#pragma header
uniform float iTime;
uniform float intensity;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) * 2.0 - 1.0;
}

float offset(float blocks, vec2 uv) {
	return rand(vec2(iTime, floor(uv.y * blocks)));
}


void main()
{
	vec2 uv = openfl_TextureCoordv;
	
    gl_FragColor = texture2D(bitmap, uv);
    
	gl_FragColor.r = texture2D(bitmap, uv + vec2(offset(16.0, uv) * (intensity * 0.01), 0.0)).r;	
	gl_FragColor.g = texture2D(bitmap, uv + vec2(offset(8.0, uv) * (intensity * 0.01) * 0.16666666, 0.0)).g;
	gl_FragColor.b = texture2D(bitmap, uv + vec2(offset(8.0, uv) * (intensity * 0.01), 0.0)).b;

}