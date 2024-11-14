# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name EnemyState extends State

enum Direction {
    UP,
    DOWN,
    LEFT,
    RIGHT
}

var direction: Direction = Direction.DOWN
var health: int

const ATTACKING = "Attacking"
const CHASING = "Chasing"
const DEAD = "Dead"
const IDLE = "Idle"
const TAKING_DAMAGE = "TakingDamage"

var enemy: Enemy


func _ready() -> void:
  await owner.ready
  enemy = owner as Enemy
  assert(enemy != null, "The EnemyState state type must be used only in the enemy scene. It needs the owner to be a Enemy node.")
  health = enemy.max_health

func get_direction_name() -> String:
  var direction_names = {
    Direction.UP: "up",
    Direction.DOWN: "down",
    Direction.LEFT: "left",
    Direction.RIGHT: "right"
  }
  return direction_names.get(direction, "unknown")