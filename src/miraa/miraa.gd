extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func _on_miraa_body_entered(body):
	anim_player.play("fade_out")
	$AudioStreamPlayer2D.play()
