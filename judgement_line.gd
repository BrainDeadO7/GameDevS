extends AnimatedSprite2D

# 현재 판정 범위 안에 들어와 있는 노트들

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			check_judgment()

# 실제로 노트를 맞혔는지 확인하는 함수
func check_judgment():
	# 현재 이 판정선(Area2D)과 겹쳐있는 모든 Area를 가져옴
	var overlapping_areas = $Area2D.get_overlapping_areas() 
	
	var hit_success = false
	for area in overlapping_areas:
		if area.is_in_group("note") and not area.is_spawner:
			# 맞췄다!
			area.destroy_note("Hit")
			hit_success = true
			break # 하나만 터뜨리고 종료

# Area2D 신호 연결: 노구가 판정 범위에 들어올 때
