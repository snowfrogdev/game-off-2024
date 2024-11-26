extends CharacterBody2D

# Maximum angle (in degrees) from the normal upon hitting the paddle edge
@export var max_bounce_angle = 45
@export var acceleration = 25
@export var start_speed = 300.0
var speed: float
var tween: Tween

func new_ball():
  visible = true
  var win_size = get_viewport_rect().size
  position.x = win_size.x / 2
  position.y = randi_range(200, win_size.y - 200)
  # Initialize the ball's velocity with a random direction towards a player
  var angle = deg_to_rad(randf_range(-30, 30))
  var direction = 1 if randf() > 0.5 else -1
  speed = start_speed
  velocity = Vector2(cos(angle), sin(angle)) * speed * direction
  

func _physics_process(delta):
    # Move the ball and handle collisions
    var collision = move_and_collide(velocity * delta)
    if collision:
        handle_collision(collision)

func handle_collision(collision: KinematicCollision2D):
  var collider = collision.get_collider()
  # Check if the collider is a paddle
  if collider.is_in_group("Paddles"):
      handle_paddle_collision(collision)
  else:
      # Reflect the velocity vector based on the collision normal
      var normal = collision.get_normal()
      velocity = velocity.bounce(normal).normalized() * speed
  scale_ball()

func handle_paddle_collision(collision: KinematicCollision2D):
    var collider: CharacterBody2D = collision.get_collider()
    var paddle_collision_shape = collider.get_node("CollisionShape2D")
    var paddle_shape = paddle_collision_shape.shape

    var paddle_size = paddle_shape.extents

    # Transform collision point to paddle's local space
    var local_collision_point = collider.to_local(collision.get_position())
    var paddle_extent = paddle_size / 2

    # Calculate the relative hit position [-1, 1]
    var relative_intersect = local_collision_point / paddle_extent
    relative_intersect = Vector2(
        clamp(relative_intersect.x, -1, 1),
        clamp(relative_intersect.y, -1, 1)
    )

    # Convert max_bounce_angle to radians
    var max_bounce_angle_rad = deg_to_rad(max_bounce_angle)

    # Calculate the new angle based on the relative y-intersect
    var bounce_angle = relative_intersect.y * max_bounce_angle_rad

    # Calculate the normal vector of the paddle's surface
    var paddle_normal = collider.transform.x

    # Update velocity
    var direction = -sign(velocity.dot(paddle_normal))
    speed += acceleration
    velocity = paddle_normal.rotated(bounce_angle) * direction * speed

func scale_ball():
  if (tween): tween.kill()
  tween = create_tween()
  tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.1)
  tween.tween_property(self, "scale", Vector2(1, 1), 0.1)