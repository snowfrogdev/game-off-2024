extends StaticBody2D


func _on_hitbox_area_entered(area: Area2D) -> void:
  if area.is_in_group("Sword"):
    $AnimatedSprite2D.play("break")


func _on_animated_sprite_2d_animation_finished() -> void:
  if $AnimatedSprite2D.animation == "break":
    queue_free()
