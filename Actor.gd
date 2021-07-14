#This script will be used for both Player and enemy

extends KinematicBody2D
class_name Actor

export var speed: = Vector2(300.0, 1000.0) #Max speed on both horizontal and vertical
export var gravity: = 3000.0 #Add .0 to clarify its a float
var velocity: = Vector2.ZERO #Vector2(300, 0) #character moves 300p on x axis. .ZERO so character doesnt just move



