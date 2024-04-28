shader_type canvas_item;

void fragment() {
    // Calculate the distance from the center of the sprite
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = FRAGCOORD.xy / vec2(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
    float distance = distance(uv, center);
    
    // If the pixel is outside the circular bounds, discard it
    if (distance > 0.5) {
        discard;
    }
    
    // Otherwise, sample the texture at the distorted UV coordinates
    vec2 distortedUV = uv + (uv - center) * (1.0 - distance * 2.0);
    COLOR = texture(TEXTURE, distortedUV);
}