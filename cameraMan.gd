extends Node

var camera
var springarm
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
				
func ThirdPerson(target,delta):
	
	var ShoulderPoint = target.get_node("ThirdPerson")
	
	# Thirdperson movment and camera is surprisingly difficult to generalize, will need to work on this more.
	
	#springarm.translation = ShoulderPoint.get_global_translation()
	#springarm.rotation = ShoulderPoint.rotation
	#var sp_loc = ShoulderPoint.get_global_translation()
	#var sp_loc = ShoulderPoint.translation
	#camera.look_at(sp_loc,Vector3.UP)
	#camera.translation = Vector3(sp_loc.x,sp_loc.y,sp_loc.z + 5)
	
	pass

func Init(obj,mode):
	
	#### Find Camera 
	#print_debug(world.find_node("Camera"))
	
	### Find Types
	for child in obj.get_children():
		if child is Position3D:
			if child.name in cameraTypes:
				foundCameraTypes[child.name] = child
	if foundCameraTypes:
		print_debug("Found: ",foundCameraTypes)
	else:
		print_debug("No Camera types found")
	
	player = obj
	var world = obj.get_parent()
	camera = Camera.new()
	if mode == "ThirdPerson":
		springarm = SpringArm.new()
		player.get_node(mode).call_deferred("add_child", springarm)
		springarm.call_deferred("add_child", camera)
		springarm.spring_length = 5
		springarm.margin = 0.2
		#springarm.set_as_toplevel(true)
	else:
		player.call_deferred("add_child",camera)
		camera.translation = Vector3(0,4,10)
	camera.make_current()
	
	return foundCameraTypes[mode]
