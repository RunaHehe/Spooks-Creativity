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
#define time iTime
//SHADERTOY PORT FIX

const float pixelSize =    4.00; // "fat pixel" size
const float zoom      =    8.00; // max zoom factor
const float radius    =  128.00; // planar movement radius
const float speed     =    0.25; // speed



////////////////////////////////////////////////////////////////////////////////////////////////////

void mainImage(  )
{
    // zoom & scroll
    vec2 pixel = 0
    float time   = iTime * speed;
	float scale  = pixelSize + ((cos((time + 8.0) / 3.7) + 1.0) / 2.0) * (zoom - 1.0) * pixelSize;
	vec2  center = vec2(-4.0, 16.0) + iResolution.xy / 2.0;
	vec2  offset = vec2(cos(time), sin(time)) * radius;

    pixel = ((pixel + offset) - center) / scale + center;

    // emulate point sampling
    vec2 uv = floor(pixel) + 0.5;
    
    // subpixel aa algorithm (COMMENT OUT TO COMPARE WITH POINT SAMPLING)
    uv += 1.0 - clamp((1.0 - fract(pixel)) * scale, 0.0, 1.0);

    // output
   	fragColor = texture(bitmap, uv / iResolution.xy);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// version with split-screen side-by-side comparison vs regular point sampling:
// https://www.shadertoy.com/view/ltBGWc

////////////////////////////////////////////////////////////////////////////////////////////////////
