class_name Enemy extends CharacterBody2D

@export var SPEED = 6000.0

@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var hurtbox_area: Area2D = $HurtboxArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_areas = {
  "left": $AttackAreas/FistAttackLeftArea,
  "right": $AttackAreas/FistAttackRightArea,
  "up": $AttackAreas/FistAttackUpArea,
  "down": $AttackAreas/FistAttackDownArea
}
