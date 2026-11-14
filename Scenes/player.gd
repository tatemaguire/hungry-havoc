class_name Player
extends CharacterBody2D

@export var speed: float = 40
@export var knockback_strength: float = 120
@export var knockback_damping: float = 240

@onready var health_component: HealthComponent = $HealthComponent

var input_vector: Vector2 = Vector2.ZERO
var knockback_vector: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	# Get movement input
	input_vector.x = Input.get_axis("Move Left", "Move Right")
	input_vector.y = Input.get_axis("Move Up", "Move Down")
	
	# Set velocity
	velocity = input_vector * speed
	
	# Apply knockback
	if knockback_vector.length() > 0.01:
		# Add knockback velocity
		velocity += knockback_vector
		# Dampen Knockback
		var new_len: float = knockback_vector.length() - knockback_damping * delta
		if new_len <= 0: new_len = 0
		knockback_vector = knockback_vector.limit_length(new_len)
	
	move_and_slide()


func _on_damage_taken(_damage: int, health: int, area: Area2D) -> void:
	print("PLAYER: ", health)
	# Trigger knockback using collision angle
	var angle: float = global_position.angle_to_point(area.global_position)
	knockback_vector = Vector2.from_angle(angle) * -knockback_strength
	
	if health <= 0:
		kill()


func kill() -> void:
	get_tree().paused = true
