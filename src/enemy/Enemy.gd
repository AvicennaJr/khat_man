extends "res://Actor.gd"

func _ready():
	set_physics_process(false) #so that the enemy doesn't start when not in view
	velocity.x = -speed.x #to start moving in the opposite direction of player
	$Tween.interpolate_property($AnimatedSprite, 'scale',
								$AnimatedSprite.scale,
								$AnimatedSprite.scale * 2, 0.1,
								Tween.TRANS_QUAD,Tween.EASE_IN_OUT) #check page 53 of book
	$Tween.interpolate_property($AnimatedSprite, 'modulate',
								Color(1,1,1,1),
								Color(1,1,1,0), 0.1,
								Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
func _on_StompDetector_body_entered(body):
	#first compare the positions of the player body to stomp area (we made it hover above enemy)
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return #return nothing
	get_node("CollisionShape2D").disabled = true #so that it no longer collides
	$StompDetector.monitoring = false
	$Tween.start()
	
func _physics_process(delta):
	velocity.y += gravity * delta
	if is_on_wall():
		velocity.x *= -1.0
	if velocity.x > 0:
		$AnimatedSprite.play('walk')
		$AnimatedSprite.flip_h = true
	if velocity.x < 0:
		$AnimatedSprite.play('walk')
		$AnimatedSprite.flip_h = false
	velocity.y = move_and_slide(velocity, Vector2.UP).y



func _on_Tween_tween_completed(object, key):
	queue_free()


func _on_BulletDetector_area_entered(area):
	if area.is_in_group("bullets"):
		$Tween.start()
