extends CharacterBody2D


@export var SPEED = 500.0
@export var STRETCH_FACTOR = 0.015


func _physics_process(delta: float) -> void:
  var direction = Input.get_axis("Move Up", "Move Down")
  
  # Move the paddle along the y axis, if it collides it should simply stop where the collision occured
  velocity.y = direction * SPEED * delta
  move_and_collide(velocity)
  
  # Stretch and squeeze based on velocity
  var stretch = 1.0 + abs(velocity.y) * STRETCH_FACTOR
  scale.y = stretch
  scale.x = 1.0 / stretch
