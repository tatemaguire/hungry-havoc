class_name Enemy
extends CharacterBody2D

@onready var player: Player = $"../Player"

@export var speed: float = 20


func _physics_process(_delta: float) -> void:
	look_at(player.global_position)
	
	var angle: float = global_position.angle_to_point(player.global_position)
	velocity = Vector2.from_angle(angle) * speed
	
	move_and_slide()
	#collision_response()
#
#func collision_response() -> void:
	#var count: int = get_slide_collision_count()
	#
	#for i in count:
		#var collision: KinematicCollision2D = get_slide_collision(i)
		#var collider: Object = collision.get_collider()
		#if collider is Player:
			#collider.
