class_name Player
extends CharacterBody2D

@export var speed: float = 40
@export var knockback_strength: float = 80

@onready var health_component: HealthComponent = $HealthComponent

var input_vector: Vector2 = Vector2.ZERO
var knockback_vector: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	# Get movement input
	input_vector.x = Input.get_axis("Move Left", "Move Right")
	input_vector.y = Input.get_axis("Move Up", "Move Down")
	
	# Set velocity and apply velocity
	velocity = input_vector * speed
	move_and_slide()


func _on_damage_taken(_damage: int, health: int, area: Area2D) -> void:
	print("PLAYER: ", health)
	
	var angle: float = global_position.angle_to_point(area.global_position)
	knockback(angle)
	
	if health <= 0:
		kill()


## TODO: knockback is incomplete
func knockback(angle: float) -> void:
	knockback_vector = Vector2.from_angle(angle) * knockback_strength


func kill() -> void:
	get_tree().paused = true
