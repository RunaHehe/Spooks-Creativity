//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define iChannel1 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
#define time iTime
//SHADERTOY PORT FIX


uniform float BlurZoom = 2.0;
uniform float BlurZoomInv = 2.0 / 2.0;

uniform int BlendMode_Mix = 0;
uniform int BlendMode_Screen = 1;

uniform int BlendMode = 0;
uniform float BlendAmount = 0.5;

#define scale_uv(uv, scale, center) ((uv - center) * scale + center)

vec3 blend_screen(vec3 a, vec3 b, float w)
{
    return 1.0 - (1.0 - a) * (1.0 - b * w);
}

void mainImage()
{
    vec4 color = texture(iChannel0, uv);
    vec2 coord = fragCoord;

    vec2 ps = 1.0 / iResolution.xy;
    vec2 uv = coord * ps;
    
    color = texture(iChannel0, uv);
    
    vec3 blur = texture(iChannel0, scale_uv(uv, BlurZoomInv, 0.5)).rgb;
    
    if (BlendMode == BlendMode_Mix)
        color.rgb = mix(color.rgb, blur, BlendAmount);
    else if (BlendMode == BlendMode_Screen)
        color.rgb = blend_screen(color.rgb, blur, BlendAmount);
    
    // Switch doesn't work for some machines.
    /*switch (BlendMode)
    {
        case BlendMode_Mix:
    		color.rgb = mix(color.rgb, blur, BlendAmount);
        	break;
        case BlendMode_Screen:
        	color.rgb = blend_screen(color.rgb, blur, BlendAmount);
        	break;
    }*/
}