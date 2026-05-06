extends CanvasLayer


func _ready():
	visible = false # 처음엔 숨김

# 외부에서 호출할 "열기" 함수
func open_pause_menu():
	get_tree().paused = true  # 게임 정지
	visible = true            # UI 표시
	# 마우스 커서가 필요하다면 추가
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 

# "해제" 버튼에 연결할 함수
func _on_button_pressed():
	print("Pressed!")
	get_tree().paused = false # 게임 재개
	visible = false           # UI 숨김
	# 게임용 마우스 모드로 복구 (필요시)
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
