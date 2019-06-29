return [[
#define MAX_LIGHTS 32
struct Light {
    vec2 position;
    vec3 diffuse;
    number strength;
    number radius;
};

extern Light lights[MAX_LIGHTS];
extern number light_count;
extern number ambient_light;
extern number breath_offset; //This could be moved to the light struct and be per-light

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
    vec4 pixel = Texel(texture, texture_coords);
    vec3 final_colour;
    for(int i = 0; i < light_count; i++)
    {
        Light light = lights[i];
        vec2 to_light = vec2(
            light.position.x - screen_coords.x,
            light.position.y - screen_coords.y
        );
        number brightness = clamp(1.0 - (length(to_light) / (lights[i].radius + breath_offset) / lights[i].strength), 0.0, 1.0);
        final_colour += lights[i].diffuse * brightness * lights[i].strength;
    }
    
    vec4 ambience = pixel * ambient_light;
    pixel.r = pixel.r * final_colour.x;
    pixel.g = pixel.g * final_colour.y;
    pixel.b = pixel.b * final_colour.z;
    return pixel + ambience;
  }
]]
