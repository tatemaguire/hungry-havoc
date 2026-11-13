class_name HealthComponent
extends Node2D

signal damage_taken(damage: int)


@export var hitbox: Area2D
@export var health: int = 10


func _ready() -> void:
	hitbox.area_entered.connect(process_hit)


func process_hit(area: Area2D) -> void:
	if area is Hurtbox:
		health -= area.damage
		print(health)
		damage_taken.emit(area.damage)
