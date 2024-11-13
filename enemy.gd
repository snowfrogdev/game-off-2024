extends CharacterBody2D

@export var SPEED = 6000.0
@export var player: Node2D
@export var chase_radius = 250.0 # Add chase radius
@export var attack_radius = 25.0 # Add attack radius

var last_direction = Vector2.DOWN # Track the last direction

func _process(delta: float) -> void:
    if player and is_player_within_radius():
        if is_player_within_attack_radius():
            perform_attack()
        else:
            move_towards_player(delta)
    else:
        velocity = Vector2.ZERO # Reset velocity when not chasing player
    play_animation()

func is_player_within_radius() -> bool:
    return global_position.distance_to(player.global_position) <= chase_radius

func is_player_within_attack_radius() -> bool:
    return global_position.distance_to(player.global_position) <= attack_radius

func move_towards_player(delta: float) -> void:
    var direction = (player.global_position - global_position).normalized()
    velocity = direction * SPEED * delta
    move_and_slide()
    if direction != Vector2.ZERO:
        last_direction = direction

func perform_attack() -> void:
    velocity = Vector2.ZERO # Stop moving when attacking
    play_attack_animation()

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

func play_attack_animation() -> void:
    if abs(last_direction.x) > abs(last_direction.y):
        if last_direction.x > 0:
            $AnimatedSprite2D.play("attack-right")
        else:
            $AnimatedSprite2D.play("attack-left")
    else:
        if last_direction.y > 0:
            $AnimatedSprite2D.play("attack-down")
        else:
            $AnimatedSprite2D.play("attack-up")