extends Node2D

const DRONE_BULLET = preload("res://weapons/drone/drone_bullet.tscn")
const MOVE_TEXTURE = preload("res://weapons/drone/drone_move.png")

@export var damage: int = 1
@export var bullet_pierce: int = 0
@export var attack_cooldown: float = 1.2
@export var follow_speed: float = 8.0
@export var orbit_radius: float = 90.0
@export var orbit_speed: float = 2.0
@export var bob_amount: float = 6.0

# 드론 이미지 크기
@export var move_scale: Vector2 = Vector2(0.6, 0.6)

var owner_player: Node2D
var orbit_angle := 0.0
var index := 0
var total_drones := 1


func setup(player: Node2D, drone_index: int, drone_total: int):
	owner_player = player
	index = drone_index
	total_drones = max(drone_total, 1)
	orbit_angle = TAU * float(index) / float(total_drones)


func _ready():
	$Sprite2D.texture = MOVE_TEXTURE
	$Sprite2D.scale = move_scale

	$AttackTimer.wait_time = attack_cooldown
	$AttackTimer.timeout.connect(_on_attack_timer_timeout)


func _physics_process(delta):
	if owner_player == null:
		queue_free()
		return

	update_movement(delta)
	update_look_direction()


func update_movement(delta):
	orbit_angle += orbit_speed * delta

	var separated_angle = orbit_angle + TAU * float(index) / float(total_drones)
	var orbit_offset = Vector2(cos(separated_angle), sin(separated_angle)) * orbit_radius

	var time = Time.get_ticks_msec() / 1000.0
	var bob_offset = Vector2(0, sin(time * 5.0 + index) * bob_amount)

	var target_position = owner_player.global_position + orbit_offset + bob_offset

	global_position = global_position.lerp(target_position, follow_speed * delta)


func update_look_direction():
	var target = find_nearest_enemy()

	if target != null:
		look_at(target.global_position)
	else:
		rotation += 0.8 * get_process_delta_time()


func _on_attack_timer_timeout():
	attack()


func attack():
	var target = find_nearest_enemy()
	if target == null:
		return

	var shoot_direction = global_position.direction_to(target.global_position)

	look_at(target.global_position)
	spawn_bullet(shoot_direction)


func spawn_bullet(shoot_direction: Vector2):
	var bullet = DRONE_BULLET.instantiate()

	get_tree().current_scene.add_child(bullet)
	bullet.global_position = $ShootingPoint.global_position
	bullet.setup(shoot_direction, damage, bullet_pierce)


func find_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("mobs")

	var nearest_enemy = null
	var nearest_distance = INF

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		if not enemy is Node2D:
			continue

		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy

	return nearest_enemy


func apply_stats(new_damage: int, new_cooldown: float, new_pierce: int, new_total_drones: int):
	damage = new_damage
	attack_cooldown = new_cooldown
	bullet_pierce = new_pierce
	total_drones = max(new_total_drones, 1)

	if has_node("AttackTimer"):
		$AttackTimer.wait_time = attack_cooldown
