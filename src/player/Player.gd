extends Actor #It will extend the Actor script

signal shoot
export (PackedScene) var Bullet
export (float) var fire_rate

var can_shoot = true
export var stomp_impulse: = 1000.0

func _ready():
	$GunTimer.wait_time = fire_rate
	$Tween.interpolate_property($AnimatedSprite, 'scale',
								$AnimatedSprite.scale,
								$AnimatedSprite.scale * 2, 0.5,
								Tween.TRANS_QUAD,Tween.EASE_IN_OUT) #check page 53 of book
	$Tween.interpolate_property($AnimatedSprite, 'modulate',
								Color(1,1,1,1),
								Color(1,1,1,0), 0.5,
								Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
func _on_EnemyDetector_area_entered(area):
	if area.global_position.y > get_node("EnemyDetector/CollisionShape2D").global_position.y:
		velocity = calculate_stomp_velocity(velocity, stomp_impulse)


func _on_EnemyDetector_body_entered(body):
	if body.global_position.y < get_node("EnemyDetector/CollisionShape2D").global_position.y:
		$CollisionShape2D.disabled = true
		$Tween.start()
	
func _physics_process(delta): #Note that it will run physics process on parent class (Actor) too 
	var direction: =  get_direction()
	#to make the character jump like mario
	var is_jump_interrupted: = Input.is_action_just_released("ui_select") and velocity.y < 0.0
	#Play animation block. Theres a better way to do this but we're lazy
	if direction.x > 0:
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
	elif direction.x < 0:
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("idle")
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		$shoot.play()
		
	#NOTE: LEFT/RIGHT OR A/D TO MOVE PLAYER || W TO SHOOT || SPACE TO JUMP
	
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	velocity = move_and_slide(velocity, Vector2.UP) #move the character tht amount of velocity. It also multiplies velocity with delta
									#vector2.up helps you jump when using move and slide

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 
		-1.0 if Input.is_action_just_pressed("ui_select") and is_on_floor() else 1.0
		)
func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	#for gravity and jump
	new_velocity.y += gravity * get_physics_process_delta_time() #the get_physics..time() is from godot
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity


func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse #basically change the jump to stomp value
	return out

func shoot():
	emit_signal("shoot", Bullet, $Muzzle.global_position, rotation)
	can_shoot = false
	$GunTimer.start()

func _on_GunTimer_timeout():
	can_shoot = true


func _on_Tween_tween_completed(object, key):
	queue_free()
