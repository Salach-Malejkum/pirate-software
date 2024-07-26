shader_type canvas_item;

uniform vec4 line_color: source_color;
uniform float amplitude = 0.5;
uniform float frequency = 2.0;
uniform float line_thickness: hint_range(0.0, 10) = 2.;
uniform bool active = false;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}


void fragment( )
{
	if (active)
	{
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
		float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
		outline = min(outline, 1.0);
		
		float pulsate = (sin(TIME * frequency) + 1.) / 2.  * amplitude + 0.3;
		vec4 color = texture(TEXTURE, UV);
		vec4 line = line_color * pulsate;
		COLOR = mix(color, line, outline - color.a);
	}
}