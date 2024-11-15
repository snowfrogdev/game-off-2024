extends EnemyState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  enemy.animated_sprite.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
  enemy.hurtbox_area.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

  var attack_direction = (enemy.player.global_position - enemy.global_position).normalized()
  
  if abs(attack_direction.x) > abs(attack_direction.y):
    if attack_direction.x > 0:
      enemy.hitboxes["right"].get_children()[0].disabled = false
      enemy.animated_sprite.play("attack-right")
      direction = Direction.RIGHT
    else:
      enemy.hitboxes["left"].get_children()[0].disabled = false
      enemy.animated_sprite.play("attack-left")
      direction = Direction.LEFT
  else:
    if attack_direction.y > 0:
      enemy.hitboxes["down"].get_children()[0].disabled = false
      enemy.animated_sprite.play("attack-down")
      direction = Direction.DOWN
    else:
      enemy.hitboxes["up"].get_children()[0].disabled = false
      enemy.animated_sprite.play("attack-up")
      direction = Direction.UP
  
  enemy.attack_cooldown_timer.start(enemy.attack_cooldown)

func exit() -> void:
  enemy.animated_sprite.disconnect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))

func _on_animated_sprite_2d_animation_finished() -> void:
  if enemy.animated_sprite.animation.begins_with("attack-"):
    for area in enemy.hitboxes.values():
      for collider in area.get_children():
        if collider is CollisionShape2D:
            collider.disabled = true
    
    finished.emit(IDLE)


func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    finished.emit(TAKING_DAMAGE)