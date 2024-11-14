extends EnemyState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  enemy.animated_sprite.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))

  enemy.velocity = Vector2()
  var animation_name = "death-" + get_direction_name()
  enemy.animated_sprite.play(animation_name)


func _on_animated_sprite_2d_animation_finished() -> void:
  if enemy.animated_sprite.animation.begins_with("death-"):
    enemy.queue_free()