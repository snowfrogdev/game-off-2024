extends PlayerState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  player.animated_sprite.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))

  player.velocity = Vector2()
  var animation_name = "death-" + get_direction_name()
  player.animated_sprite.play(animation_name)


func _on_animated_sprite_2d_animation_finished() -> void:
  if player.animated_sprite.animation.begins_with("death-"):
    player.queue_free()