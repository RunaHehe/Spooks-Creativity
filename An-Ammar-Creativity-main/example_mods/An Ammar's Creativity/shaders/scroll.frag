// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

//SHADERTOY PORT FIX
#pragma header
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
#define time iTime
//SHADERTOY PORT FIX

// https://www.shadertoy.com/view/WtGGRt

uniform float timeMulti; // 0.2
uniform float xSpeed; // 0.5
uniform float ySpeed; //  0.00

void mainImage()
{
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;

    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    
    float time = iTime * timeMulti;
    
    // no floor makes it squiqqly
    float xCoord = floor(fragCoord.x + time * xSpeed * iResolution.x);
    float yCoord = floor(fragCoord.y + time * ySpeed * iResolution.y);
    
    vec2 coord = vec2(xCoord, yCoord);
    coord = mod(coord, iResolution.xy);
 
    
    
	vec2 uv = coord/iResolution.xy;
    // Time varying pixel color
    //vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    float col = flixel_texture2D(iChannel0, uv).x;


    //vec3 color = vec3(col);

    vec4 color = flixel_texture2D(iChannel0, uv);
    
    
    
    // Output to screen
    fragColor = color;// * flixel_texture2D(iChannel0, uv) + flixel_texture2D(iChannel0, uv);
}