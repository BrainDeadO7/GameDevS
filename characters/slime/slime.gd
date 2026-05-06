extends Node2D


func play_walk():
	if %AnimationPlayer.has_animation("walk"):
		%AnimationPlayer.play("walk")


func play_hurt():
	if %AnimationPlayer.has_animation("hurt"):
		%AnimationPlayer.play("hurt")
		if %AnimationPlayer.has_animation("walk"):
			%AnimationPlayer.queue("walk")
