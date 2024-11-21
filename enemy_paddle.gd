extends CharacterBody2D

enum Difficulty {EASY, MEDIUM, HARD}
@export var difficulty = Difficulty.MEDIUM
var SPEED = 400.0
var REACTION_TIME = 0.2
var ERROR_MARGIN = 30.0

@export var ball: CharacterBody2D
var reaction_timer = 0.0
var target_position = 0.0

func _ready():
    set_difficulty_parameters()

func set_difficulty_parameters():
    match difficulty:
        Difficulty.EASY:
            SPEED = 300.0
            REACTION_TIME = 0.4
            ERROR_MARGIN = 50.0
        Difficulty.MEDIUM:
            SPEED = 400.0
            REACTION_TIME = 0.2
            ERROR_MARGIN = 30.0
        Difficulty.HARD:
            SPEED = 500.0
            REACTION_TIME = 0.1
            ERROR_MARGIN = 10.0

func _physics_process(delta: float) -> void:
    if ball:
        reaction_timer -= delta
        if reaction_timer <= 0:
            target_position = ball.position.y + randf_range(-ERROR_MARGIN, ERROR_MARGIN)
            reaction_timer = REACTION_TIME

        var direction = target_position - position.y
        var movement = clamp(direction, -SPEED * delta, SPEED * delta)
        velocity.y = movement
        move_and_collide(velocity)
