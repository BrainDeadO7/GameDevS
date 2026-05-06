extends ProgressBar

# 플레이어 노드 참조 (Unique Name 사용 추천)
@onready var player = get_node("%Player") 

func _process(_delta):
	if player:
		# 1. 최대치 설정 (required_exp)
		self.max_value = player.required_exp
		
		# 2. 현재치 설정 (exp)
		self.value = player.exp
