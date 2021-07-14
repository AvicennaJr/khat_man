extends Area2D

export (int) var bulletspeed
var bulletvelocity = Vector2()


#copy/pasted from an old space shooter game. has issues I have to fix
func start(pos, dir):
	position = pos
	rotation = dir
	bulletvelocity = Vector2(bulletspeed, 0).rotated(dir)
	
func _process(delta):
	position += bulletvelocity * delta
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	queue_free()
