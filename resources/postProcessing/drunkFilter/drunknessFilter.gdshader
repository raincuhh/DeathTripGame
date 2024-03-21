shader_type canvas_item;

uniform float distortion_amount : hint_range(0.0, 1.0);
uniform float blur_amount : hint_range(0.0, 1.0);
uniform vec2 screen_size; // Uniform for screen size

void fragment() {
    vec2 uv = FRAGCOORD.xy / screen_size; 

    // Output UV coordinates as color (for debugging)
    COLOR = vec4(uv, 0.0, 1.0);

    // Apply distortion based on the distortion_amount parameter
    uv.x += (sin(uv.y * 100.0) * distortion_amount) * 0.05;
    uv.y += (cos(uv.x * 100.0) * distortion_amount) * 0.05;

    // Apply blur based on the blur_amount parameter
    vec4 color = vec4(0.0);
    for (float x = -5.0 * blur_amount; x <= 5.0 * blur_amount; x += 1.0) {
        for (float y = -5.0 * blur_amount; y <= 5.0 * blur_amount; y += 1.0) {
            color += texture(TEXTURE, uv + vec2(x, y) / screen_size); 
        }
    }
    color /= 121.0;

    // Output the final color
    COLOR = color;
}
