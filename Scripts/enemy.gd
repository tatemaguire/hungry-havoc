class_name Enemy
extends CharacterBody2D

@onready var player: Player = $"../Player"

@export var speed: float = 20


func _physics_process(_delta: float) -> void:
	look_at(player.global_position)
	
	var angle: float = global_position.angle_to_point(player.global_position)
	velocity = Vector2.from_angle(angle) * speed
	
	move_and_slide()


func _on_damage_taken(_damage: int, health: int, _area: Area2D) -> void:
	print("ENEMY: ", health)
	if health <= 0:
		kill()


func kill() -> void:
	queue_free()
