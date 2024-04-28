shader_type canvas_item;

uniform sampler2D mask;
uniform float mask_translation: hint_range(0.0, 1.0, 0.01);
const float offset = 0.1;
uniform bool enabled = false;
void fragment() {
    vec2 uv = FRAGCOORD.xy / vec2(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
    vec4 color1 = texture(TEXTURE, UV);
    vec4 color2 = texture(mask, UV - vec2(0.0, (mask_translation - offset)));
    
    if (color2.a == 0.0 ) {
        discard;
    }
    
    COLOR = color1 * color2.a;
}