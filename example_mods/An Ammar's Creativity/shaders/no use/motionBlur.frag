#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main


const int log2NumSamplesPerPass = 5;
const int numSamplesPerPass = 1 << log2NumSamplesPerPass;
const float framePeriod = 1. / 60.;
const int numPasses = 4;
const float globalGamma = 2.2;

float motionAngle(float t)
{
    float c = cos(t / 4.);
    return pow(abs(c), 1. / 3.) * sign(c) * 500.;
}

vec3 sampleRadialBlur(sampler2D tex, vec2 uv, vec4 xfrm, vec2 ths, float gamma, int pass)
{
//    float periodFraction = pow(float(numSamplesPerPass), float(-(numPasses - pass)));
    float periodFraction = exp2(float(-(numPasses - pass)) * float(log2NumSamplesPerPass));

    vec3 col = vec3(0);

    for(int i = 0; i < numSamplesPerPass; ++i)
    {
        float th = mix(ths.x, ths.y, float(i) / float(numSamplesPerPass) * periodFraction);
        vec2 uv2 = mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;
        col += pow(textureLod(tex, uv2 * xfrm.xy + xfrm.zw, -256.).rgb, vec3(gamma));
    }

    col /= float(numSamplesPerPass);
    
    return col;
}


void mainImage( )
{
    vec2 uv = (fragCoord - iResolution.xy * .5) / iResolution.y;
    
    float th0 = motionAngle(iTime);
    float th1 = motionAngle(iTime + framePeriod);

    vec3 col = sampleRadialBlur(iChannel0, uv, vec4(1.0, 1.0, 0.0, 0.0), vec2(th0, th1), globalGamma, 1);

    fragColor = vec4(col, 1.0);
}