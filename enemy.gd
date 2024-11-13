extends CharacterBody2D

@export var SPEED = 6000.0
@export var player: Node2D

var last_direction = Vector2.DOWN # Track the last direction

func _process(delta: float) -> void:
    if player:
        move_towards_player(delta)
        play_animation()

func move_towards_player(delta: float) -> void:
    var direction = (player.global_position - global_position).normalized()
    velocity = direction * SPEED * delta
    move_and_slide()
    if direction != Vector2.ZERO:
        last_direction = direction

func play_animation() -> void:
    if velocity.length() > 0:
        if abs(velocity.x) > abs(velocity.y):
            if velocity.x > 0:
                $AnimatedSprite2D.play("run-right")
            else:
                $AnimatedSprite2D.play("run-left")
        else:
            if velocity.y > 0:
                $AnimatedSprite2D.play("run-down")
            else:
                $AnimatedSprite2D.play("run-up")
    else:
        if abs(last_direction.x) > abs(last_direction.y):
            if last_direction.x > 0:
                $AnimatedSprite2D.play("idle-right")
            else:
                $AnimatedSprite2D.play("idle-left")
        else:
            if last_direction.y > 0:
                $AnimatedSprite2D.play("idle-down")
            else:
                $AnimatedSprite2D.play("idle-up")