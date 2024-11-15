extends PlayerState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  player.hurtbox_area.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))
  updateAnimation()

func exit() -> void:
  player.hurtbox_area.disconnect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

func physics_update(delta: float) -> void:
  movement_input = Input \
    .get_vector("Move Left", "Move Right", "Move Up", "Move Down") \
    .normalized()
    
  if Input.is_action_just_pressed("Attack"):
    finished.emit(ATTACKING)
  elif movement_input == Vector2.ZERO:
    finished.emit(IDLE, {"direction_name": get_direction_name()})
  else:
    player.velocity = movement_input * player.SPEED * delta
    player.move_and_slide()
    updateAnimation()

func updateAnimation() -> void:
  updateDirection()
  var animation_name = "sword-run-" + get_direction_name()
  player.animated_sprite.play(animation_name)

func updateDirection() -> void:
  if abs(movement_input.x) > abs(movement_input.y):
      if movement_input.x > 0:
          direction = Direction.RIGHT
      else:
          direction = Direction.LEFT
  else:
      if movement_input.y > 0:
          direction = Direction.DOWN
      else:
          direction = Direction.UP

func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    finished.emit(TAKING_DAMAGE)