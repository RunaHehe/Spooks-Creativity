#pragma header

vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

#define PI 3.14159265358979323846
#define e  2.71828182845904523

float r(float n)
{
 	return fract(cos(n*89.42)*343.42);
}
vec2 r(vec2 n)
{
 	return vec2(r(n.x*23.62-300.0+n.y*34.35),r(n.x*45.13+256.0+n.y*38.89)); 
}
float worley(vec2 n,float s)
{
    float dis = 2.0;
    for(int x = -1;x<=1;x++)
    {
        for(int y = -1;y<=1;y++)
        {
            vec2 p = floor(n/s)+vec2(x,y);
            float d = length(r(p)+vec2(x,y)-fract(n/s));
            if (dis>d)
            {
             	dis = d;   
            }
        }
    }
    return 1.0 - dis;
	
}

// copy from https://www.shadertoy.com/view/4sc3z2

#define MOD3 vec3(.1031,.11369,.13787)

vec3 hash33(vec3 p3)
{
	p3 = fract(p3 * MOD3);
    p3 += dot(p3, p3.yxz+19.19);
    return -1.0 + 2.0 * fract(vec3((p3.x + p3.y)*p3.z, (p3.x+p3.z)*p3.y, (p3.y+p3.z)*p3.x));
}
float perlin_noise(vec3 p)
{
    vec3 pi = floor(p);
    vec3 pf = p - pi;
    
    vec3 w = pf * pf * (3 - 2.0 * pf);
    
    return 	mix(
        		mix(
                	mix(dot(pf - vec3(0, 0, 0), hash33(pi + vec3(0, 0, 0))), 
                        dot(pf - vec3(1, 0, 0), hash33(pi + vec3(1, 0, 0))),
                       	w.x),
                	mix(dot(pf - vec3(0, 0, 1), hash33(pi + vec3(0, 0, 1))), 
                        dot(pf - vec3(1, 0, 1), hash33(pi + vec3(1, 0, 1))),
                       	w.x),
                	w.z),
        		mix(
                    mix(dot(pf - vec3(0, 1, 0), hash33(pi + vec3(0, 1, 0))), 
                        dot(pf - vec3(1, 1, 0), hash33(pi + vec3(1, 1, 0))),
                       	w.x),
                   	mix(dot(pf - vec3(0, 1, 1), hash33(pi + vec3(0, 1, 1))), 
                        dot(pf - vec3(1, 1, 1), hash33(pi + vec3(1, 1, 1))),
                       	w.x),
                	w.z),
    			w.y);
}

vec2 size = vec2(50.0, 50.0);
vec2 distortion = vec2(50.0, 100.0);
float speed = 4.;

void main( )
{
    //warp thingi
    vec2 uvWarp = uv;
    if (uvWarp.x > 0.5)
    	uvWarp.x = 1. - uvWarp.x;
    
    uvWarp.x = (uvWarp.x+0.25) * 0.5* pow(uvWarp.x+0.25, 2.0);
    uvWarp.y = (uvWarp.y-0.5) * (uvWarp.x*20.);
    
    float dis = (1.0+perlin_noise(vec3(uvWarp + iTime/3,(0))*50.0)* (1.0+(worley(fragCoord.xy, 32.0)+
        0.5*worley(2.0*fragCoord.xy,32.0) +
        0.25*worley(4.0*fragCoord.xy,32.0))));

    float inverseLength = 1.0 / length(uvWarp*8);
    float inverseLength2 = 1.0 / length(uvWarp*20);
    vec3 finalwarp = vec3(inverseLength * dis,inverseLength * dis/2 * 0.2,0); //COLOR
    
    //spiral
    vec2 transformed = vec2(
        fragCoord.x + sin(fragCoord.y / size.x + iTime * speed) * distortion.x * dis,
        fragCoord.y
    );
    vec2 uv2 = (sin(iTime)*2.5 + 20.) * (transformed - .5 * iResolution.xy) / iResolution.x;

    float r = length(uv2);
    float a = atan(uv2.y, uv2.x) - iTime*1.5;
        
    float b = fract((log(abs(log(r)))*12.+a)/6.28);
    float db = fwidth(b)*1.5;
    fragColor = vec4(vec3(smoothstep(.25+db, .25, b)*smoothstep(db, db+db, b)), 1.);
    
    float cw = 1./7.;
    float c = mod((r+a)/6.28, cw);
    float dc = fwidth(r)*6.28;
    fragColor.rgb *= vec3(0.8,0.0,0) - smoothstep(0.,cw, c) + smoothstep(cw-dc, cw-2.*dc, c) * vec3(0.5,0.0,0);

    //final
    vec4 sampler2d = texture2D(bitmap,uv);
    fragColor += vec4(finalwarp,1);
}