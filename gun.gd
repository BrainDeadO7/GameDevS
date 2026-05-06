extends Area2D


func _process(_delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var min_dist = INF
		var target_enemy
		for enemy in enemies_in_range:
			var current_dist = global_position.distance_to(enemy.global_position)
			if current_dist<min_dist:
				min_dist = current_dist
				target_enemy=enemy
		look_at(target_enemy.global_position)


func shoot():
	const BULLET = preload("res://bullet_2d.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	%ShootingPoint.add_child(new_bullet)

func rhythm():
	return null



func _on_timer_timeout() -> void:
	shoot()
