extends CharacterBody2D

@export var SPEED = 6000.0
@export var player: Node2D
@export var chase_radius = 250.0
@export var attack_radius = 25.0
@export var max_health = 100 # Add max health

signal enemy_destroyed

var last_direction = Vector2.DOWN
var is_dead = false
var is_taking_damage = false # Flag to indicate taking damage
var current_health = max_health # Initialize current health

func _process(delta: float) -> void:
    if is_dead or is_taking_damage:
        return
    if player and is_player_within_radius():
        if is_player_within_attack_radius():
            perform_attack()
        else:
            move_towards_player(delta)
    else:
        velocity = Vector2.ZERO
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
    velocity = Vector2.ZERO
    play_attack_animation()

func play_animation() -> void:
    if is_dead or is_taking_damage:
        return
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
    if is_dead or is_taking_damage:
        return
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

func _on_hitbox_area_entered(area: Area2D) -> void:
    if area.is_in_group("Sword"):
        take_damage(25) # Adjust damage value as needed

func take_damage(amount: int) -> void:
    if is_dead:
        return
    current_health -= amount
    if current_health <= 0:
        is_dead = true
        play_death_animation()
    else:
        is_taking_damage = true
        play_take_damage_animation() # Ensure this is called
        $AnimatedSprite2D.stop() # Stop the current animation
        $AnimatedSprite2D.play($AnimatedSprite2D.animation) # Restart the take-damage animation

func play_take_damage_animation() -> void:
    if is_dead:
        return
    if abs(last_direction.x) > abs(last_direction.y):
        if last_direction.x > 0:
            $AnimatedSprite2D.play("take-damage-right")
        else:
            $AnimatedSprite2D.play("take-damage-left")
    else:
        if last_direction.y > 0:
            $AnimatedSprite2D.play("take-damage-down")
        else:
            $AnimatedSprite2D.play("take-damage-up")

func play_death_animation() -> void:
    if abs(last_direction.x) > abs(last_direction.y):
        if last_direction.x > 0:
            $AnimatedSprite2D.play("death-right")
        else:
            $AnimatedSprite2D.play("death-left")
    else:
        if last_direction.y > 0:
            $AnimatedSprite2D.play("death-down")
        else:
            $AnimatedSprite2D.play("death-up")

func _on_animated_sprite_2d_animation_finished() -> void:
    if $AnimatedSprite2D.animation.begins_with("death-"):
        enemy_destroyed.emit()
        queue_free()
    elif $AnimatedSprite2D.animation.begins_with("take-damage-"):
        is_taking_damage = false # Reset the flag when take-damage animation finishes