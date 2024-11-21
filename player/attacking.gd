extends PlayerState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  player.animation_player.connect("animation_finished", Callable(self, "_on_animation_player_animation_finished"))
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
  
  player.rotation = attack_direction.angle()
  player.animation_player.play("attacking")


func exit() -> void:
  player.animation_player.disconnect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
  player.hurtbox_area.disconnect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

func _on_animation_player_animation_finished(_animation_name: String) -> void:
  finished.emit(IDLE)

func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    finished.emit(TAKING_DAMAGE)