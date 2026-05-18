extends Node2D

const BOOMERANG_PROJECTILE = preload("res://weapons/boomerang/boomerang_projectile.tscn")

@export var damage: int = 5
@export var cooldown: float = 1.0
@export var projectile_count: int = 1

var level := 1


func _ready():
	$Timer.wait_time = cooldown
	$Timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	attack()


func attack():
	var target = find_nearest_enemy()
	var shoot_direction: Vector2

	if target != null:
		shoot_direction = global_position.direction_to(target.global_position)
	else:
		shoot_direction = Vector2.RIGHT

	for i in projectile_count:
		var angle_offset = get_spread_angle(i, projectile_count)
		spawn_boomerang(shoot_direction.rotated(angle_offset))


func spawn_boomerang(shoot_direction: Vector2):
	var boomerang = BOOMERANG_PROJECTILE.instantiate()

	get_tree().current_scene.add_child(boomerang)
	boomerang.global_position = global_position
	boomerang.setup(get_parent(), shoot_direction, damage)


func find_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("mobs")

	var nearest_enemy = null
	var nearest_distance = INF

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue

		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy

	return nearest_enemy


func get_spread_angle(index: int, total: int) -> float:
	if total <= 1:
		return 0.0

	var spread_degrees := 25.0
	var start_angle := -spread_degrees * 0.5
	var step := spread_degrees / float(total - 1)

	return deg_to_rad(start_angle + step * index)


func upgrade():
	level += 1

	match level:
		2:
			damage += 1
		3:
			cooldown *= 0.8
			$Timer.wait_time = cooldown
		4:
			projectile_count += 1
		5:
			damage += 1
			projectile_count += 1
