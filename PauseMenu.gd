extends CanvasLayer

@onready var player = get_node("/root/Game/Player")
@onready var player_skills = player.player_skills #스킬이 딕셔너리 형태로 여기 저장됨
@onready var ui_skill1:Label = $Button2/skill
@onready var ui_skill2:Label = $Button3/skill
@onready var ui_skill3:Label = $Button4/skill
@onready var ui_lvl1:Label = $Button2/lvl
@onready var ui_lvl2:Label = $Button3/lvl
@onready var ui_lvl3:Label = $Button4/lvl

var skill_list = ["gun","swip","throwing","magic","shield"]
var temp = skill_list.duplicate()
func _ready():
	visible = false # 처음엔 숨김

func when_opened(button_number):
	if button_number == 1:
		pass
	elif button_number == 2:
		pass
	elif button_number == 3:
		pass
		

# 외부에서 호출할 "열기" 함수
func open_pause_menu():
	get_tree().paused = true  # 게임 정지
	visible = true            # UI 표시
	#스킬 3개 shuffle
	temp = skill_list.duplicate()
	#스킬 이름 + 레벨 ui에 표기
	if len(temp)>2: #3개 이상
		temp.shuffle()
		temp = temp.slice(0,3) #temp에 3개를 할당
		#스킬 적힌걸로 ui 변경
		ui_skill1.text = temp[0]
		ui_skill2.text = temp[1]
		ui_skill3.text = temp[2]
		ui_lvl1.text = "lvl "+str(player_skills[temp[0]])+" -> lvl "+str((player_skills[temp[0]]+1))
		ui_lvl2.text = "lvl "+str(player_skills[temp[1]])+" -> lvl "+str((player_skills[temp[1]]+1))
		ui_lvl3.text = "lvl "+str(player_skills[temp[2]])+" -> lvl "+str((player_skills[temp[2]]+1))
	elif len(temp)==2: #2개만 있을때
		pass
		#스킬 적힌걸로 ui 변경
		ui_skill1.text = temp[0]
		ui_skill2.text = temp[1]
		ui_skill3.text = "X"
		ui_lvl1.text = "lvl "+str(player_skills[temp[0]])+" -> lvl "+str((player_skills[temp[0]]+1))
		ui_lvl2.text = "lvl "+str(player_skills[temp[1]])+" -> lvl "+str((player_skills[temp[1]]+1))
		ui_lvl3.text = ""
	elif len(temp)==1: #1개만 있을때
		ui_skill1.text = temp[0]
		ui_skill2.text = "X"
		ui_skill3.text = "X"
		ui_lvl1.text = "lvl "+str(player_skills[temp[0]])+" -> lvl "+str((player_skills[temp[0]]+1))
		ui_lvl2.text = ""
		ui_lvl3.text = ""
	else: #0개일 때
		ui_skill1.text = "X"
		ui_skill2.text = "X"
		ui_skill3.text = "X"
		ui_lvl1.text = ""
		ui_lvl2.text = ""
		ui_lvl3.text = ""
func skip():
	get_tree().paused = false # 게임 재개
	visible = false           # UI 숨김

# "해제" 버튼에 연결할 함수
func _on_button_pressed(): #Cancel
	skip()          # UI 숨김
	# 게임용 마우스 모드로 복구 (필요시)
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func levelup(n):
	if len(temp)>n:
		player_skills[temp[n]] +=1
		if player_skills[temp[n]] > 4:
			skill_list.erase(temp[n]) #레벨이 5라면 만렙이므로 스킬리스트에서 삭제
		skip()

func _on_button_2_pressed():
	levelup(0)
	#print("%s has upgraded! now %d level!"%[temp[0], player_skills[temp[0]]])



func _on_button_3_pressed():
	levelup(1)
	#print("%s has upgraded! now %d level!"%[temp[1], player_skills[temp[1]]])



func _on_button_4_pressed():
	levelup(2)
	#print("%s has upgraded! now %d level!"%[temp[2], player_skills[temp[2]]])
