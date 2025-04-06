shader_type canvas_item;

uniform float y_threshold = 0.0;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    float distance_from_threshold = UV.y - y_threshold;
    
    if (distance_from_threshold > 0.0) {
        COLOR = vec4(original_color.r, original_color.g, original_color.b, min(original_color.a, 0.25));
    } else {
        COLOR = original_color;
    }
}