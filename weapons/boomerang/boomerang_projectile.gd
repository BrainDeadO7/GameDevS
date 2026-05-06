extends Area2D

@export var damage: int = 5
@export var speed: float = 1000.0
@export var max_distance: float = 650.0
@export var return_distance: float = 35.0

var owner_player: Node2D
var direction: Vector2 = Vector2.RIGHT
var start_position: Vector2
var returning := false

var hit_bodies: Array[Node] = []


func setup(player: Node2D, shoot_direction: Vector2, weapon_damage: int = 1):
	owner_player = player
	direction = shoot_direction.normalized()
	damage = weapon_damage
	start_position = global_position
	returning = false


func _ready():
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	if owner_player == null:
		queue_free()
		return

	$Sprite2D.rotate(12.0 * delta)

	if not returning:
		global_position += direction * speed * delta

		var travelled_distance = global_position.distance_to(start_position)
		if travelled_distance >= max_distance:
			returning = true
	else:
		var return_direction = global_position.direction_to(owner_player.global_position)
		global_position += return_direction * speed * delta

		if global_position.distance_to(owner_player.global_position) <= return_distance:
			queue_free()


func _on_body_entered(body):
	if hit_bodies.has(body):
		return

	hit_bodies.append(body)

	if body.has_method("take_damage"):
		body.take_damage(damage)
