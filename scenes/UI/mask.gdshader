shader_type canvas_item;

uniform sampler2D maskTexture;
uniform vec2 maskTranslation;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
    vec4 animatedColor = texture(TEXTURE, UV);
	
    // Translate UV coordinates for the mask
    vec2 translatedUV = UV - maskTranslation;
	
    vec4 maskColor = texture(maskTexture, translatedUV);

    // Apply the mask
    COLOR = animatedColor * maskColor;
}