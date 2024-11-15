extends PlayerState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  player.animated_sprite.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
  player.hurtbox_area.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))
  take_damage(25)

func exit() -> void:
  player.animated_sprite.disconnect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
  player.hurtbox_area.disconnect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

func take_damage(amount: int) -> void:
  player.velocity = Vector2()
  player.animated_sprite.stop()

  health -= amount
  if health <= 0:
    finished.emit(DEAD)
  else:
    var animation_name = "take-damage-" + get_direction_name()
    player.animated_sprite.play(animation_name)

func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    take_damage(25)

func _on_animated_sprite_2d_animation_finished() -> void:
  if player.animated_sprite.animation.begins_with("take-damage-"):
    finished.emit(IDLE, {"direction_name": get_direction_name()})