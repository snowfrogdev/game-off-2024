extends PlayerState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  player.animated_sprite.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
  player.hurtbox_area.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

  movement_input = Input \
    .get_vector("Move Left", "Move Right", "Move Up", "Move Down") \
    .normalized()
  
  var attack_direction = Vector2.ZERO
  if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
    var mouse_position = player.get_global_mouse_position()
    attack_direction = (mouse_position - player.global_position).normalized()
  else:
    attack_direction = movement_input
  
  if abs(attack_direction.x) > abs(attack_direction.y):
    if attack_direction.x > 0:
      player.attack_areas["right"].get_children()[0].disabled = false
      player.animated_sprite.play("sword-attack-right")
      direction = Direction.RIGHT
    else:
      player.attack_areas["left"].get_children()[0].disabled = false
      player.animated_sprite.play("sword-attack-left")
      direction = Direction.LEFT
  else:
    if attack_direction.y > 0:
      player.attack_areas["down"].get_children()[0].disabled = false
      player.animated_sprite.play("sword-attack-down")
      direction = Direction.DOWN
    else:
      player.attack_areas["up"].get_children()[0].disabled = false
      player.animated_sprite.play("sword-attack-up")
      direction = Direction.UP

func exit() -> void:
  player.animated_sprite.disconnect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
  player.hurtbox_area.disconnect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

func _on_animated_sprite_2d_animation_finished() -> void:
  if player.animated_sprite.animation.begins_with("sword-attack-"):
    for area in player.attack_areas.values():
      for collider in area.get_children():
        if collider is CollisionShape2D:
            collider.disabled = true
    
    finished.emit(IDLE, {"direction_name": get_direction_name()})

func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    finished.emit(TAKING_DAMAGE)