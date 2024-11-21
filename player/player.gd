class_name Player extends CharacterBody2D

@export var SPEED = 7000.0
@export var max_health = 100 # Add max health

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox_area: Area2D = $HurtboxArea

var movement_input = Vector2.ZERO