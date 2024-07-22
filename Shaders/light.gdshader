shader_type canvas_item;

uniform vec2 u_resolution;
uniform float radius = 0.3;

void vertex() {
	UV = UV * 2. - 1.;
	UV.x *= u_resolution.x / u_resolution.y;
}

void fragment() {
	float d = length(UV);
	
	d = abs(d);
	d = step(radius, d);
	
	vec3 black = vec3(0.);
	black *= d;
	
	COLOR = vec4(black, d);
}
