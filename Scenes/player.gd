class_name Player
extends CharacterBody2D

@export var speed: float = 1
var input_vector: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# Get movement input
	input_vector.x = Input.get_axis("Move Left", "Move Right")
	input_vector.y = Input.get_axis("Move Up", "Move Down")
	
	print(input_vector)
	
	# Set velocity and apply velocity
	velocity = input_vector * speed
	move_and_slide()
