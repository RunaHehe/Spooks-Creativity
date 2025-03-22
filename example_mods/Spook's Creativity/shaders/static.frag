#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;

float noise(vec2 pos, float evolve) {
    
    // Loop the evolution (over a very long period of time).
    float e = fract((evolve*0.01));
    
    // Coordinates
    float cx  = pos.x*e;
    float cy  = pos.y*e;
    
    // Generate a "random" black or white value
    return fract(23.0*fract(2.0/fract(fract(cx*2.4/cy*23.0+pow(abs(cy/22.4),3.3))*fract(cx*evolve/pow(abs(cy),0.050)))));
}


void main()
{
    int intensity = 1;
    
    vec4 color = flixel_texture2D(bitmap, uv);
    for (int i = 0; i < intensity; i++)
        {
        // Generate a black to white pixel
        color.rgb = vec3(noise(fragCoord,iTime)) * color.a;
        }
	
    // Output to screen
    gl_FragColor = color;
}