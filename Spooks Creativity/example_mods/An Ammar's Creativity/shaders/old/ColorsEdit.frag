//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//SHADERTOY PORT FIX

const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);

vec3 avgluma = vec3 (0.62, 0.62, 0.62);
uniform float saturation;
uniform float contrast;
uniform float brightness;


void mainImage()
{
 
    vec2 uv = fragCoord/iResolution.xy;

    
    vec3 texColor  	= texture(iChannel0, uv).rgb; 
	vec3 intensity 	= vec3 (dot(texColor, LumCoeff));
	vec3 color     	= mix(intensity, texColor, saturation);
	color          	= mix(avgluma, color, contrast);
	color			*= brightness;

    float theAlpha = flixel_texture2D(bitmap,uv).a;
	
    fragColor = vec4 (color, theAlpha);
    
}