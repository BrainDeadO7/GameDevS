extends Node2D

@export var fade_delay: float = 0.5
@export var fade_duration: float = 1.5


func _ready():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("explosion")

	await get_tree().create_timer(fade_delay).timeout

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)

	await tween.finished
	queue_free()
