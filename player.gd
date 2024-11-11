extends CharacterBody2D

@export var SPEED = 7000.0

var input: Vector2
var state: String = "idle"
var attack_timer: Timer
var last_direction: String = "down"

func _process(_delta: float) -> void:
    if state == "idle" or state == "moving":
        input = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
        input = input.normalized()
        if input != Vector2.ZERO:
            state = "moving"
        else:
            state = "idle"
        update_animations()

func _physics_process(_delta: float) -> void:
    if state == "idle" or state == "moving":
        velocity = input * SPEED * _delta
        move_and_slide()

func update_animations() -> void:
    if Input.is_action_just_pressed("Attack") and state != "attacking":
        handle_attack()
    elif state == "moving":
        if Input.is_action_pressed("Move Left"):
            $AnimatedSprite2D.play("sword-run-left")
            last_direction = "left"
        elif Input.is_action_pressed("Move Right"):
            $AnimatedSprite2D.play("sword-run-right")
            last_direction = "right"
        elif Input.is_action_pressed("Move Up"):
            $AnimatedSprite2D.play("sword-run-up")
            last_direction = "up"
        elif Input.is_action_pressed("Move Down"):
            $AnimatedSprite2D.play("sword-run-down")
            last_direction = "down"
    else:
        state = "idle"
        match last_direction:
            "left":
                $AnimatedSprite2D.play("sword-idle-left")
            "right":
                $AnimatedSprite2D.play("sword-idle-right")
            "up":
                $AnimatedSprite2D.play("sword-idle-up")
            "down":
                $AnimatedSprite2D.play("sword-idle-down")

func handle_attack() -> void:
    state = "attacking"
    match last_direction:
        "left":
            $AnimatedSprite2D.play("sword-attack-left")
        "right":
            $AnimatedSprite2D.play("sword-attack-right")
        "up":
            $AnimatedSprite2D.play("sword-attack-up")
        "down":
            $AnimatedSprite2D.play("sword-attack-down")
    

func _on_animated_sprite_2d_animation_finished() -> void:
  if state == "attacking":
    state = "idle"
    update_animations()