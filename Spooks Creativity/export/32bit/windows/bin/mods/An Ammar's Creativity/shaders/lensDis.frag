// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

uniform float intensity;

vec2 computeUV( vec2 uv, float k, float kcube ){
    
    vec2 t = uv - .5;
    float r2 = t.x * t.x + t.y * t.y;
	float f = 0.;
    
    if( kcube == 0.0){
        f = 1. + r2 * k;
    }else{
        f = 1. + r2 * ( k + kcube * sqrt( r2 ) );
    }
    
    vec2 nUv = f * t + .5;
    nUv.y = 1. - nUv.y;
 
    return nUv;
    
}

void mainImage() {
    
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;

	vec2 uv = fragCoord.xy / iResolution.xy;
    uv.y = 1. - uv.y;
    float k = 1.0 *  (intensity * .9 );
    float kcube = .5 * ( intensity );
    
    float offset = .1 * ( intensity * .5 );

    float theAlpha = flixel_texture2D(bitmap,uv).a;
    
    float red = flixel_texture2D( bitmap, computeUV( uv, k + offset, kcube )).r; 
    float green = flixel_texture2D( bitmap, computeUV( uv, k, kcube )).g; 
    float blue = flixel_texture2D( bitmap, computeUV( uv, k - offset, kcube )).b; 
    
    fragColor = vec4( red, green,blue, theAlpha );

}