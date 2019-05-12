return [[
#define MAX_LIGHTS 32
struct Light {
    vec2 position;
    vec3 diffuse;
    number strength;
    number radius;
};
extern Light lights[MAX_LIGHTS];
extern number lightCount;
extern number ambientLight;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );
    vec3 finalColour;
    for(int i = 0; i < lightCount; i++)
    {
        Light light = lights[i];
        vec2 toLight = vec2(light.position.x - screen_coords.x, light.position.y - screen_coords.y);
        number brightness = clamp(1.0 - (length(toLight) / lights[i].radius / lights[i].strength), 0.0, 1.0);
        finalColour += lights[i].diffuse * brightness * lights[i].strength;
    }
    
    vec4 newAmbient = pixel * ambientLight;
    pixel.r = pixel.r * finalColour.x;
    pixel.g = pixel.g * finalColour.y;
    pixel.b = pixel.b * finalColour.z;
    return pixel + newAmbient;
  }
]]
