extends PlayerState

func enter(_previous_state_path: String, data: Dictionary = {}) -> void:
  player.hurtbox_area.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))
  player.velocity = Vector2()
  player.animation_player.play("idle")

func exit() -> void:
  player.hurtbox_area.disconnect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

func physics_update(_delta: float) -> void:
  movement_input = Input \
    .get_vector("Move Left", "Move Right", "Move Up", "Move Down") \
    .normalized()

  if Input.is_action_just_pressed("Attack"):
    finished.emit(ATTACKING)
  elif movement_input != Vector2.ZERO:
    finished.emit(MOVING)

func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    finished.emit(TAKING_DAMAGE)