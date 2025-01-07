// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

//SHADERTOY PORT FIX
#pragma header

#define fragColor gl_FragColor
#define mainImage main
//SHADERTOY PORT FIX

uniform float PIXEL_FACTOR; // Lower num - bigger pixels 500
uniform float COLOR_FACTOR;   // Higher num - higher colors quality  8

const mat4 ditherTable = mat4(
    -4.0, 0.0, -3.0, 1.0,
    2.0, -2.0, 3.0, -1.0,
    -3.0, 1.0, -4.0, 0.0,
    3.0, -1.0, 2.0, -2.0
);

void mainImage()
{                  
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;

    // Reduce pixels            
    vec2 size = PIXEL_FACTOR * iResolution.xy/iResolution.x;
    vec2 uv = floor( fragCoord/iResolution.xy * size) / size;   
                 
    vec3 col = flixel_texture2D(bitmap, uv).xyz;     
    float theAlpha = flixel_texture2D(bitmap,uv).a;

    // Reduce colors
    col = floor(col * COLOR_FACTOR) / COLOR_FACTOR;    
   
    // Output to screen
    fragColor = vec4(col,theAlpha);
}