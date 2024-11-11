extends Node2D

@export var pot_scene: PackedScene
@export var number_of_pots: int = 10
@export var spawn_radius: float = 200.0

func _ready() -> void:
  randomize()
  for i in range(number_of_pots):
      spawn_pot()

func spawn_pot() -> void:
  var pot_instance = pot_scene.instantiate()
  pot_instance.set("spawner", self) # Pass the reference to the spawner
  var random_position = Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
  pot_instance.position = position + random_position
  pot_instance.connect("pot_destroyed", Callable(self, "_on_pot_destroyed"))
  add_child(pot_instance)

func _on_pot_destroyed() -> void:
  spawn_pot()