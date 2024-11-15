extends EnemyState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
  enemy.player_detection_area.connect("body_exited", Callable(self, "_on_player_detection_area_body_exited"))
  enemy.attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))
  enemy.hurtbox_area.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))
  
  # Check if the player is already in the detection area
  for body in enemy.attack_area.get_overlapping_bodies():
    if body is Player:
      _on_attack_area_body_entered(body)
      return

  update_animation()

func physics_update(delta: float) -> void:
  move_towards_player(delta)

func exit() -> void:
  enemy.player_detection_area.disconnect("body_exited", Callable(self, "_on_player_detection_area_body_exited"))
  enemy.attack_area.disconnect("body_entered", Callable(self, "_on_attack_area_body_entered"))
  enemy.hurtbox_area.disconnect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

func move_towards_player(delta: float) -> void:
  var player_direction = (enemy.player.global_position - enemy.global_position).normalized()
  enemy.velocity = player_direction * enemy.SPEED * delta
  enemy.move_and_slide()
  update_direction(player_direction)
  update_animation()

func update_direction(player_direction: Vector2) -> void:
  if abs(player_direction.x) > abs(player_direction.y):
      if player_direction.x > 0:
          direction = Direction.RIGHT
      else:
          direction = Direction.LEFT
  else:
      if player_direction.y > 0:
          direction = Direction.DOWN
      else:
          direction = Direction.UP

func update_animation() -> void:
  var animation_name = "run-" + get_direction_name()
  enemy.animated_sprite.play(animation_name)

func _on_player_detection_area_body_exited(body: Node2D) -> void:
  if body is Player:
    finished.emit(IDLE)

func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    finished.emit(TAKING_DAMAGE)

func _on_attack_area_body_entered(body: Node2D) -> void:
  if body is Player:
    finished.emit(ATTACKING)