extends PlayerState

func enter(_previous_state_path: String, data: Dictionary = {"direction_name": "down"}) -> void:
  player.velocity = Vector2()
  var animation_name = "sword-idle-" + data["direction_name"]
  player.animated_sprite.play(animation_name)

func physics_update(_delta: float) -> void:
  movement_input = Input \
    .get_vector("Move Left", "Move Right", "Move Up", "Move Down") \
    .normalized()

  if Input.is_action_just_pressed("Attack"):
    finished.emit(ATTACKING)
  elif movement_input != Vector2.ZERO:
    finished.emit(MOVING)