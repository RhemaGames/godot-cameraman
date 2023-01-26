extends Node

var camera
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(player,close,far,delta):
	### Falls behind if obj is acellerating 
	if player.thrust_input == 1:
		if camera.translation.z > -far:
			camera.translation.z -= 2*delta
	else:
		if camera.translation.z < -close:
			camera.translation.z += 2.5*delta
	pass

func init(obj,chaser):
	player = obj
	camera = chaser
