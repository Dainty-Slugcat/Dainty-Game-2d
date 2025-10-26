extends Node2D

@onready var anim_sprite = $RigidBody2D/animated_sprite2D

func _ready():
	anim_sprite.play("fly")
