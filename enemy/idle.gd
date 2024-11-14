extends EnemyState


func enter(_previous_state_path: String, data: Dictionary = {"direction_name": "down"}) -> void:
  enemy.player_detection_area.connect("body_entered", Callable(self, "_on_player_detection_area_body_entered"))
  enemy.hurtbox_area.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

  enemy.velocity = Vector2()
  var animation_name = "idle-" + data["direction_name"]
  enemy.animated_sprite.play(animation_name)

func exit() -> void:
  enemy.player_detection_area.disconnect("body_entered", Callable(self, "_on_player_detection_area_body_entered"))
  enemy.hurtbox_area.disconnect("area_entered", Callable(self, "_on_hurtbox_area_entered"))

func _on_player_detection_area_body_entered(body: Node2D) -> void:
  if body is Player:
    # Log to the console
    print("Player detected!")
    # finished.emit(CHASING)

func _on_hurtbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Weapons"):
    finished.emit(TAKING_DAMAGE)