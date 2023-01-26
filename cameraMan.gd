extends Node

var camera
var player
var cameraTypes = ["Chase","Orbit","Free","FirstPerson","ThirdPerson"]
var foundCameraTypes:Dictionary

signal locked()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Chase(target,close,far,delta):
	if camera and foundCameraTypes.has("Chase"):
		var chaser = foundCameraTypes["Chase"]
		camera.transform = chaser.transform
		### Falls behind if obj is acellerating 
		if target.movement_input["thrust"] == 1:
			if chaser.translation.z < far:
				chaser.translation.z += 2*delta
		else:
			if chaser.translation.z > close:
				chaser.translation.z -= 2.5*delta

func Init(obj):
	player = obj

	### Find Camera 
	camera = obj.find_node("Camera")
	
	### Find Types
	for child in obj.get_children():
		if child is Position3D:
			if child.name in cameraTypes:
				foundCameraTypes[child.name] = child
	if foundCameraTypes:
		print_debug("Found: ",foundCameraTypes)
	else:
		print_debug("No Camera types found")
