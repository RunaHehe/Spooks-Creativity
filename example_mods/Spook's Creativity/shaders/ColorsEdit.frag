// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

//SHADERTOY PORT FIX
#pragma header

#define iChannel0 bitmap
#define fragColor gl_FragColor
#define mainImage main
//SHADERTOY PORT FIX

const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);
const vec3 avgluma = vec3 (0.62, 0.62, 0.62);

uniform float saturation; // 1
uniform float contrast; // 1
uniform float brightness; // 1


void mainImage()
{
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
	vec2 iResolution = openfl_TextureSize;
    vec2 uv = fragCoord/iResolution.xy;

    
    vec3 texColor  	= flixel_texture2D(iChannel0, uv).rgb; 
	vec3 intensity 	= vec3 (dot(texColor, LumCoeff));
	vec3 color     	= mix(intensity, texColor, saturation);
	color          	= mix(avgluma, color, contrast);
	color			*= brightness;

    float theAlpha = flixel_texture2D(bitmap,uv).a;
	
    fragColor = vec4 (color, theAlpha);
    
}