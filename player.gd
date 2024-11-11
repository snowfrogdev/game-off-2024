extends CharacterBody2D

@export var SPEED = 7000.0
@export_range(0.0, 1.0) var TRAUMA_VALUE = 0.1

var input: Vector2
var state: String = "idle"
var last_direction: String = "down"

func _ready() -> void:
    $AttackAreas/SwordAttackLeftArea.connect("area_entered", Callable(self, "_on_attack_area_entered"))
    $AttackAreas/SwordAttackRightArea.connect("area_entered", Callable(self, "_on_attack_area_entered"))
    $AttackAreas/SwordAttackUpArea.connect("area_entered", Callable(self, "_on_attack_area_entered"))
    $AttackAreas/SwordAttackDownArea.connect("area_entered", Callable(self, "_on_attack_area_entered"))

func _process(_delta: float) -> void:
    input = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
    input = input.normalized()
    if input != Vector2.ZERO and state != "attacking":
        state = "moving"
    elif state != "attacking":
        state = "idle"
    if state == "idle" or state == "moving":
        update_animations()

func _physics_process(_delta: float) -> void:
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
    var direction = Vector2.ZERO
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
      var mouse_position = get_global_mouse_position()
      direction = (mouse_position - global_position).normalized()
    else:
      direction = input
    
    if abs(direction.x) > abs(direction.y):
        if direction.x > 0:
            $AnimatedSprite2D.play("sword-attack-right")
            last_direction = "right"
        else:
            $AnimatedSprite2D.play("sword-attack-left")
            last_direction = "left"
    else:
        if direction.y > 0:
            $AnimatedSprite2D.play("sword-attack-down")
            last_direction = "down"
        else:
            $AnimatedSprite2D.play("sword-attack-up")
            last_direction = "up"

func _on_animated_sprite_2d_animation_finished() -> void:
    if state == "attacking":
        state = "idle"
        for child in $AttackAreas.get_children():
            if child is Area2D:
                for collider in child.get_children():
                    if collider is CollisionShape2D:
                        collider.disabled = true
        update_animations()

func _on_animated_sprite_2d_frame_changed() -> void:
    if $AnimatedSprite2D.frame == 3:
        match ($AnimatedSprite2D.animation):
            "sword-attack-left":
                $AttackAreas/SwordAttackLeftArea/CollisionShape2D.disabled = false
            "sword-attack-right":
                $AttackAreas/SwordAttackRightArea/CollisionShape2D.disabled = false
            "sword-attack-up":
                $AttackAreas/SwordAttackUpArea/CollisionShape2D.disabled = false
            "sword-attack-down":
                $AttackAreas/SwordAttackDownArea/CollisionShape2D.disabled = false

func _on_attack_area_entered(area: Area2D) -> void:
    if area.is_in_group("Hittable"):
        $Camera2D.add_trauma(TRAUMA_VALUE)