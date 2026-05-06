extends CharacterBody2D

signal health_depleted

var health = 100.0
@export var required_exp = 3
var exp: int = 0:
	set(value):
		exp = value
		if exp == required_exp:
			level+=1
			exp = 0
			required_exp = level*2+3

var level: int = 0:
	set(value):
		level = value
		level_up()

func _physics_process(delta):
	const SPEED = 600.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	# Taking damage
	const DAMAGE_RATE = 6.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%HealthBar.value = health
		if health <= 0.0:
			health_depleted.emit()

func level_up():
	print("LEVEL UP! | ",level," now!")
	var menu = get_node_or_null("%LevelUpMenu") # %는 Unique Name 기호
	if menu:
		menu.open_pause_menu()
	
