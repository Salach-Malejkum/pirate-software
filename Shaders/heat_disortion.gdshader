shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D noise_texture: repeat_enable;
uniform float speed: hint_range(0.02, 0.1) = 0.01;
uniform float strength: hint_range(0.001, 0.03) = 0.02;
uniform vec2 direction;

void fragment() {
	float noise = texture(noise_texture, UV + TIME * speed).r;
	vec2 disortion = vec2(noise) * direction;
	COLOR = texture(screen_texture, SCREEN_UV + disortion - disortion * strength / 2.);
}
