extends Area2D
class_name BasePortal

@export var twin: BasePortal = null
@export var tile_size: int = 16

@onready var obstacle_ray: RayCast2D = $ObstacleRayCast
@onready var push_ray: RayCast2D = $PushRayCast
@onready var tail_ray: RayCast2D = $TailRayCast
@onready var out_tile: Marker2D = $Out

@onready var random_player: RandomStreamPlayer = $RandomStreamPlayer

var rotation_values = {
	"up": 0,
	"right": 90,
	"left": 270,
	"down": 180
}

var own_dir: String = ""


func _ready():
	set_dir()

func traverse(head: SnakeHead) -> void:
	head.global_position = twin.out_tile.global_position.snapped(Vector2.ONE * tile_size)

	if twin.own_dir == "down":
		head.position.x -= Vector2.ONE.x * tile_size / 2
		head.position.y += Vector2.ONE.y * tile_size / 2
	elif twin.own_dir == "right":
		head.position.x += Vector2.ONE.x * tile_size / 2
		head.position.y -= Vector2.ONE.y * tile_size / 2
	elif twin.own_dir == "left":
		head.position.x -= Vector2.ONE.x * tile_size / 2
		head.position.y += Vector2.ONE.y * tile_size / 2
	elif twin.own_dir == "up":
		head.position.x -= Vector2.ONE.x * tile_size / 2
		head.position.y -= Vector2.ONE.y * tile_size / 2
	
	if twin.push_ray.is_colliding():
		twin.push_ray.get_collider().push(twin.own_dir)
	
	head.sprite.rotation_degrees = twin.rotation_degrees
	head.previous_direction = twin.own_dir

	random_player.play_random()

	

func set_dir() -> void:
	for dir in rotation_values:
		if rotation_values[dir] >= rotation_degrees - 1 && rotation_values[dir] <= rotation_degrees + 1:
			own_dir = dir

func can_be_traversed() -> bool:
	if twin.obstacle_ray.is_colliding():
		return false
	if twin.push_ray.is_colliding():
		return twin.push_ray.get_collider().can_be_pushed(twin.own_dir)
	return true
