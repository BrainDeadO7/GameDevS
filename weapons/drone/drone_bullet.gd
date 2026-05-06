extends Area2D

@export var damage: int = 1
@export var speed: float = 900.0
@export var bullet_range: float = 900.0
@export var pierce: int = 0

# 총알 색상만 코드에서 조정
@export var bullet_color: Color = Color(0.2, 0.8, 1.0, 1.0)

# 평소에는 false로 둔다.
# true로 켜면 아래 bullet_scale 값으로 Sprite2D 스케일을 강제로 덮어쓴다.
@export var override_sprite_scale: bool = false
@export var bullet_scale: Vector2 = Vector2(1.0, 1.0)

var direction: Vector2 = Vector2.RIGHT
var travelled_distance := 0.0
var hit_count := 0
var hit_bodies: Array[Node] = []


func setup(shoot_direction: Vector2, bullet_damage: int = 1, bullet_pierce: int = 0):
	direction = shoot_direction.normalized()
	damage = bullet_damage
	pierce = bullet_pierce
	rotation = direction.angle()


func _ready():
	if has_node("Sprite2D"):
		$Sprite2D.modulate = bullet_color

		if override_sprite_scale:
			$Sprite2D.scale = bullet_scale

	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	var movement = direction * speed * delta
	global_position += movement
	travelled_distance += movement.length()

	if travelled_distance >= bullet_range:
		queue_free()


func _on_body_entered(body):
	if hit_bodies.has(body):
		return

	hit_bodies.append(body)

	if body.has_method("take_damage"):
		body.take_damage(damage)

	hit_count += 1

	if hit_count > pierce:
		queue_free()
