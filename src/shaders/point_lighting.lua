return [[
#define NUM_LIGHTS 32
struct Light {
    vec2 pos;
    vec3 diffuse;
    number power;
};
extern Light lights[NUM_LIGHTS];
extern number numLights;
extern number ambientLight;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );
    vec3 finalColour;
    for(int i = 0; i < numLights; i++)
    {
        Light light = lights[i];
        vec2 toLight = vec2(light.pos.x - screen_coords.x, light.pos.y - screen_coords.y);
        number brightness = clamp(1.0 - (length(toLight) / 300 / lights[i].power), 0.0, 1.0);
        finalColour += lights[i].diffuse * brightness * lights[i].power;
    }
    
    vec4 newAmbient = pixel * ambientLight;
    pixel.r = pixel.r * finalColour.x;
    pixel.g = pixel.g * finalColour.y;
    pixel.b = pixel.b * finalColour.z;
    return pixel + newAmbient;
  }
]]
