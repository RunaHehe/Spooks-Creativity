#pragma header

uniform vec2 u_top;

void main() {
	vec2 uv = vec2(openfl_TextureCoordv.x, 1.0 - openfl_TextureCoordv.y);
	
	vec2 bottom = vec2(0.0, 1.0), top = u_top;
	if (top.y > 1.0) {
		top.x /= top.y;
		bottom.y /= top.y;
		
		top.y = 1.0;
	} else if (top.x < 0.0) {
		top.x = 1.0 - top.x;
		
		top.y = 1.0 - (1.0 - top.y) / top.x;
		bottom.x = 1.0 - (1.0 - bottom.x) / top.x;
		
		top.x = 0.0;
	}
	
	vec2 side = mix(bottom, top, uv.y);
	uv = vec2((uv.x - side.x) / (side.y - side.x), 1.0 - uv.y);
	
	gl_FragColor = (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) ? vec4(0.0) : flixel_texture2D(bitmap, uv);
}