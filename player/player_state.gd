# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name PlayerState extends State

enum Direction {
    UP,
    DOWN,
    LEFT,
    RIGHT
}

var direction: Direction = Direction.DOWN
var movement_input = Vector2.ZERO
var health: int

const ATTACKING = "Attacking"
const DEAD = "Dead"
const IDLE = "Idle"
const MOVING = "Moving"
const TAKING_DAMAGE = "TakingDamage"

var player: Player


func _ready() -> void:
  await owner.ready
  player = owner as Player
  assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
  health = player.max_health

func get_direction_name() -> String:
  var direction_names = {
    Direction.UP: "up",
    Direction.DOWN: "down",
    Direction.LEFT: "left",
    Direction.RIGHT: "right"
  }
  return direction_names.get(direction, "unknown")