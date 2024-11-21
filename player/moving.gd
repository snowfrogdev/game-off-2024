extends PlayerState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  player.hurtbox_area.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))
  player.animation_player.play("moving")

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
    updateDirection()

func updateDirection() -> void:
  if movement_input.length() > 0:
      player.rotation = movement_input.angle()

func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    finished.emit(TAKING_DAMAGE)