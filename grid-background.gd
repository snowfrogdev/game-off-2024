extends Node2D

# Grid spacing in pixels
@export var grid_size: int = 32
# Grid color
@export var grid_color: Color = Color(0.5, 0.5, 0.5, 0.5)
# Extra grid coverage around the viewport (in pixels)
@export var extra_grid_coverage: int = 200

func _ready():
    # Request that the grid be drawn immediately
    queue_redraw()

func _draw():
    # Get the camera's global position (assumes there's a camera in the scene)
    var camera = get_viewport().get_camera_2d()
    var camera_position = camera.get_global_position() if camera else Vector2.ZERO
    
    # Get the viewport size and extend it by the extra coverage
    var viewport_size = get_viewport_rect().size
    var grid_area_start = camera_position - viewport_size / 2 - Vector2(extra_grid_coverage, extra_grid_coverage)
    var grid_area_end = camera_position + viewport_size / 2 + Vector2(extra_grid_coverage, extra_grid_coverage)

    # Calculate the starting x and y based on grid alignment with camera offset
    var start_x = int(grid_area_start.x / grid_size) * grid_size
    var start_y = int(grid_area_start.y / grid_size) * grid_size

    # Draw vertical lines
    for x in range(start_x, int(grid_area_end.x), grid_size):
        draw_line(Vector2(x, grid_area_start.y), Vector2(x, grid_area_end.y), grid_color)

    # Draw horizontal lines
    for y in range(start_y, int(grid_area_end.y), grid_size):
        draw_line(Vector2(grid_area_start.x, y), Vector2(grid_area_end.x, y), grid_color)

func _process(_delta: float) -> void:
    # Continuously update the grid to adapt to camera movements
    queue_redraw()
