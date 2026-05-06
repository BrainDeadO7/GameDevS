extends Area2D

# 자기 자신의 씬 파일을 미리 로드합니다. (경로를 본인의 파일 경로에 맞게 수정하세요)
const NOTE_SCENE = preload("res://Note.tscn")

# 새로 소환된 노트들이 또 노트를 소환하는 '무한 복제'를 막기 위한 변수
var is_spawner = true

# 이동 관련 변수
@export var convergence_speed: float = 100.0 
	
func _ready():
	# 만약 이 노드가 스폰용이 아니라면(방금 소환된 노트라면) 타이머를 작동시키지 않습니다.
	if not is_spawner:
		$Timer.stop()
	else:
		$Timer.wait_time = 1

func _on_timer_timeout():
	if is_spawner:
		spawn_notes()

func spawn_notes():
	# 1. 오른쪽 노트 소환 (+122)
	#var note_right = NOTE_SCENE.instantiate()
	#note_right.is_spawner = false # 새로 생긴 노드는 소환 능력을 끕니다 (do nothing)
	#get_parent().add_child(note_right)
	#note_right.visible = true
	#note_right.position = position + Vector2(122, 0)
	
	# 2. 왼쪽 노트 소환 (-122)
	var note_left = NOTE_SCENE.instantiate()
	note_left.is_spawner = false # 새로 생긴 노드는 소환 능력을 끕니다 (do nothing)
	get_parent().add_child(note_left)
	note_left.visible = true
	note_left.position = position + Vector2(-122, 0)

func _process(delta):
	# 핵심: 소환된 노트(is_spawner가 false)일 때만 이동
	if not is_spawner:
		# x좌표를 0을 향해 이동시킴
		position.x = move_toward(position.x, 0, convergence_speed * delta)
		if position.x == 0:
			self.destroy_note("Miss")

func destroy_note(reason: String):
	# Hit인 경우 파티클 재생 등 추가 연출 가능
	if (reason == "Hit"):
		print("Hit")
	elif reason == "Miss":
		print("Miss")
	queue_free()
