extends Node2D

const DRONE_SCENE = preload("res://weapons/drone/drone.tscn")

@export var damage: int = 1
@export var attack_cooldown: float = 1.2
@export var drone_count: int = 1
@export var bullet_pierce: int = 0

var level := 1
var drones: Array[Node] = []


func _ready():
	print("DroneWeapon ready. parent = ", get_parent())
	call_deferred("rebuild_drones")


func rebuild_drones():
	print("DroneWeapon: rebuild_drones called")
	clear_drones()

	var player = get_parent()
	if player == null:
		print("ERROR: DroneWeapon has no parent")
		return

	for i in drone_count:
		var drone = DRONE_SCENE.instantiate()

		get_tree().current_scene.add_child(drone)

		drone.global_position = player.global_position
		print("Drone created at: ", drone.global_position)

		drone.setup(player, i, drone_count)
		drone.apply_stats(damage, attack_cooldown, bullet_pierce, drone_count)

		drones.append(drone)


func clear_drones():
	for drone in drones:
		if is_instance_valid(drone):
			drone.queue_free()

	drones.clear()


func apply_stats_to_drones():
	for i in drones.size():
		var drone = drones[i]
		if not is_instance_valid(drone):
			continue

		drone.index = i
		drone.total_drones = drone_count
		drone.apply_stats(damage, attack_cooldown, bullet_pierce, drone_count)


func upgrade():
	level += 1

	match level:
		2:
			damage += 1
			apply_stats_to_drones()
		3:
			attack_cooldown *= 0.8
			apply_stats_to_drones()
		4:
			drone_count += 1
			call_deferred("rebuild_drones")
		5:
			bullet_pierce += 1
			damage += 1
			apply_stats_to_drones()


func rhythm_attack(judgement := "good"):
	for drone in drones:
		if not is_instance_valid(drone):
			continue

		drone.attack()

	if judgement == "perfect":
		for drone in drones:
			if not is_instance_valid(drone):
				continue

			drone.attack()
