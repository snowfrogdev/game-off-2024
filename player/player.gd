class_name Player extends CharacterBody2D

@export var SPEED = 7000.0
@export var max_health = 100 # Add max health

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox_area: Area2D = $HurtboxArea
@onready var attack_areas = {
  "left": $AttackAreas/SwordAttackLeftArea,
  "right": $AttackAreas/SwordAttackRightArea,
  "up": $AttackAreas/SwordAttackUpArea,
  "down": $AttackAreas/SwordAttackDownArea
}

var movement_input = Vector2.ZERO