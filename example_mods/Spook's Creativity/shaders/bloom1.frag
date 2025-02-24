#pragma header
        
uniform float shadeAmount = 0.6;
vec2 offset = vec2(0.0, 0.0);
vec3 multColors = vec3(0.0, 0.0, 0.0);

float bloomIntensity = 1.0;
float bloomRadius = 10.0;

const int blurPasses = 5;

void main(void)
{
      vec2 newUV = openfl_TextureCoordv - offset;

      vec4 originalColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

      if (originalColor.a > 0.0) {
    
            if (newUV.x >= 0.0 && newUV.y >= 0.0 && newUV.x <= 1.0 && newUV.y <= 1.0) {
            
                  vec4 movedColor = flixel_texture2D(bitmap, newUV);
                  if (movedColor.a > 0.0) {
                    originalColor.rgb -= shadeAmount;
                    originalColor.b += multColors.b;
                  }else{
                    originalColor.g *= multColors.g;
                    originalColor.r *= multColors.r;
                  }
              
                  vec4 bloom = vec4(0.0);
                  float totalWeight = 0.0;
                  vec2 texelSize = vec2(1.0 / openfl_TextureSize);
              
                  for (int i = 0; i < blurPasses; i++) {
                        float weight = exp(-float(i * i) / (2.0 * bloomRadius * bloomRadius));
                        vec2 offset = vec2(float(i), 0.0) * texelSize;
                
                        bloom += flixel_texture2D(bitmap, openfl_TextureCoordv + offset) * weight;
                        bloom += flixel_texture2D(bitmap, openfl_TextureCoordv - offset) * weight;
                
                        totalWeight += 2.0 * weight;
                  }
              
                  bloom /= totalWeight;
                  originalColor += bloomIntensity * bloom;
              
                  gl_FragColor = originalColor;
              
            } else {
            
                    originalColor.g *= multColors.g;
                    originalColor.r *= multColors.r;
                  gl_FragColor = originalColor;
            }
        
      } else {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
      }
}