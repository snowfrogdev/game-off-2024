class_name Player extends CharacterBody2D

@export var SPEED = 7000.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_areas = {
  "left": $AttackAreas/SwordAttackLeftArea,
  "right": $AttackAreas/SwordAttackRightArea,
  "up": $AttackAreas/SwordAttackUpArea,
  "down": $AttackAreas/SwordAttackDownArea
}

var movement_input = Vector2.ZERO