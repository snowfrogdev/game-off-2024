extends CharacterBody2D


@export var SPEED = 500.0


func _physics_process(delta: float) -> void:
  var direction = Input.get_axis("Move Up", "Move Down")
  
  # Move the paddle along the y axis, if it collides it should simply stop where the collision occured
  velocity.y = direction * SPEED * delta
  move_and_collide(velocity)
