extends Camera2D

@export var decay = 0.8 # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 100) # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1 # Maximum rotation in radians (use sparingly).

var trauma = 0.0 # Current shake strength.
var trauma_power = 2 # Trauma exponent. Use [2, 3].

@onready var noise = FastNoiseLite.new()
var noise_y = 0.0

func _ready() -> void:
  noise.seed = randi()
  noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
  noise.frequency = 1.0 / 4.0
  noise.fractal_type = FastNoiseLite.FRACTAL_FBM
  noise.fractal_octaves = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if trauma:
    trauma = max(trauma - decay * delta, 0)
    shake()

func shake():
  var amount = pow(trauma, trauma_power)
  noise_y += 1
  rotation = max_roll * amount * noise.get_noise_2d(0, noise_y)
  offset.x = max_offset.x * amount * noise.get_noise_2d(1, noise_y)
  offset.y = max_offset.y * amount * noise.get_noise_2d(2, noise_y)

func add_trauma(value: float) -> void:
  trauma = min(trauma + value, 1.0)
