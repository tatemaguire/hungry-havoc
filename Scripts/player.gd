class_name Player
extends CharacterBody2D

signal crate_collected(total: int)

@onready var dash_sound: AudioStreamPlayer2D = $DashSound

@export var speed: float = 80
## Bullets per second
@export var firing_speed: float = 2.5
@export var knockback_strength: float = 120
@export var knockback_damping: float = 240

@export var win_text: RichTextLabel;

@export_group("Damage Effect")
@export var damage_effect_length: float = 0.1
@export var damage_effect_color: Color = Color.FIREBRICK

@onready var health_component: HealthComponent = $HealthComponent
@onready var bullet_spawn_point: Node2D = $BulletSpawnPoint
@onready var sprite: Sprite2D = $Sprite2D

@export_group("Dash Dodge")
@export var dash_distance = 100.0
@export var invincibility_duration = 0.4 # in seconds


var pizza_scene: PackedScene = preload("res://Scenes/pizza_projectile.tscn")

var input_vector: Vector2 = Vector2.ZERO
var knockback_vector: Vector2 = Vector2.ZERO
var firing_cooldown: float = 0
var cratesCollected = 0

var hearts_list : Array[TextureRect]


func _ready() -> void:
	var hearts_parent = $"../HealthUI/HBoxContainer"
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	print(hearts_list)


func _process(delta: float) -> void:
	firing_cooldown -= delta
	
	if firing_cooldown <= 0 && Input.is_action_pressed("Attack"):
		attack()
		# Reset cooldown
		firing_cooldown = 1 / firing_speed
		
	if Input.is_action_just_pressed("Dash"):
		print("DASHED")
		dash()

func attack() -> void:
	var pizza: Area2D = pizza_scene.instantiate()
	pizza.global_transform = bullet_spawn_point.global_transform
	add_sibling(pizza)


func _physics_process(delta: float) -> void:
	movement_input()
	rotate_with_movement()
	apply_knockback(delta)
	move_and_slide()


func movement_input() -> void:
	# Get movement input
	input_vector.x = Input.get_axis("Move Left", "Move Right")
	input_vector.y = Input.get_axis("Move Up", "Move Down")
	input_vector = input_vector.normalized()
	
	# Set velocity
	velocity = input_vector * speed

# Can double down as a dash or dodge mechanic
func dash() -> void:
	var facing: Vector2 = Vector2.RIGHT.rotated(global_rotation)
	move_and_collide(facing * dash_distance)
	dash_sound.play()

func invincibility() -> void:
	set_collision_mask_value(3, false)
	await get_tree().create_timer(invincibility_duration).timeout
	set_collision_mask_value(3, true)


func rotate_with_movement() -> void:
	look_at(position + input_vector* 100)


func apply_knockback(delta: float) -> void:
	# Apply knockback
	if knockback_vector.length() > 0.01:
		# Add knockback velocity
		velocity += knockback_vector
		# Dampen Knockback
		var new_len: float = knockback_vector.length() - knockback_damping * delta
		if new_len <= 0: new_len = 0
		knockback_vector = knockback_vector.limit_length(new_len)


func _on_damage_taken(_damage: int, health: int, area: Area2D) -> void:
	print("PLAYER: ", health)
	
	
	# Update Heart Display
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health
	
	sprite.modulate = damage_effect_color
	var timer: SceneTreeTimer = get_tree().create_timer(damage_effect_length)
	timer.timeout.connect(func(): sprite.modulate = Color.WHITE)
	
	# Trigger knockback using collision angle
	var angle: float = global_position.angle_to_point(area.global_position)
	knockback_vector = Vector2.from_angle(angle) * -knockback_strength
	
	if health <= 0:
		#kill()
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

func kill() -> void:
	get_tree().paused = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("crate"):
		area.queue_free()
		cratesCollected += 1
		print(cratesCollected)
		crate_collected.emit(cratesCollected)
	if area.is_in_group("door"):
		if (cratesCollected >= 5):
			print("Escaped!")
			win_text.visible = true
			get_tree().paused = true
		else:
			print("Find the other crates first!")
			
			
