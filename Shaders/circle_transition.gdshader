shader_type canvas_item;

uniform vec2 u_resolution;
uniform float progress;

void vertex() {
	UV = UV * 2. - 1.;
	UV.x *= u_resolution.x / u_resolution.y;
}

void fragment() {
	float d = length(UV);
	
	d = sin(d / 5.+ progress);
	d = abs(d);
	d = step(0.3, d);
	vec3 color = vec3(1. - d);
	COLOR = vec4(color, d);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
