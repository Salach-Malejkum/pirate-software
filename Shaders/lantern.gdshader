shader_type canvas_item;

uniform float oscilation_power: hint_range(0.0, 5.0, 0.2) = 1.5;

void vertex() {
	float oscilation = sin(TIME);
	if (VERTEX.y > 0.)
		VERTEX.x = VERTEX.x + oscilation * oscilation_power;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
