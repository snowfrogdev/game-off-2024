class_name Enemy extends CharacterBody2D

@export var SPEED = 6000.0
@export var max_health = 100
@export var player: Node2D
@export var attack_cooldown = 1.0

@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var attack_area: Area2D = $AttackArea
@onready var hurtbox_area: Area2D = $HurtboxArea
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitboxes = {
  "left": $Hitboxes/FistAttackLeftArea,
  "right": $Hitboxes/FistAttackRightArea,
  "up": $Hitboxes/FistAttackUpArea,
  "down": $Hitboxes/FistAttackDownArea
}

