extends Node2D


func play_idle_animation():
	if %AnimationPlayer.has_animation("idle"):
		%AnimationPlayer.play("idle")


func play_walk_animation():
	if %AnimationPlayer.has_animation("walk"):
		%AnimationPlayer.play("walk")
