extends Node2D

@export var particle_node: CPUParticles2D
@export var canvas_modulate: CanvasModulate

#func _ready():
	#if particle_node and canvas_modulate:
		## Assuming you want the particles to be white regardless of the CanvasModulate
		#var desired_color = Color(1.0, 1.0, 1.0, 1.0)  # White color
		#
		## Set the particle color to the desired color
		#particle_node.modulate = desired_color
		#
		## Iterate over each particle material and set the color
		#if particle_node.process_material:
			#var material = particle_node.process_material
			#if material is ShaderMaterial:
				#material.set_shader_param("color", desired_color)
			#elif material is ParticleProcessMaterial:
				#material.color = desired_color
				#material.color_ramp = null  # Ensure color ramp doesn't affect the color
		#
		## Print the modulate color for reference
		#print("Particle Modulate Color: ", particle_node.modulate)
	#else:
		#print("Particle node or CanvasModulate node is not assigned.")
