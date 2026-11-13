class_name Enemy
extends CharacterBody2D

@export var player: Player

@export var speed: float = 10

func _physics_process(_delta: float) -> void:
	look_at(player.global_position)
	
	var angle: float = global_position.angle_to_point(player.global_position)
	velocity = Vector2.from_angle(angle) * speed
	
	move_and_slide()
