extends Node

var camera
var springarm
var player
var cameraTypes = ["Chase","Orbit","Free","FirstPerson","ThirdPerson"]
var foundCameraTypes:Dictionary
@export var far = 3000

signal locked()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Chase(target,close,far,delta):
	if foundCameraTypes.has("Chase"):
		camera = foundCameraTypes["Chase"].get_child(0)
		camera.make_current()
		var chaser = foundCameraTypes["Chase"]
		camera.transform = chaser.transform
		### Falls behind if obj is acellerating 
		if target.movement_input["thrust"] == 1:
			if chaser.position.z < far:
				chaser.position.z += 2*delta
		else:
			if chaser.position.z > close:
				chaser.position.z -= 2.5*delta
				
func ThirdPerson(target,delta):
	
	var ShoulderPoint = target.get_node("ThirdPerson")
	
	# Thirdperson movment and camera is surprisingly difficult to generalize, will need to work checked this more.
	
	#springarm.position = ShoulderPoint.get_global_translation()
	#springarm.rotation = ShoulderPoint.rotation
	#var sp_loc = ShoulderPoint.get_global_translation()
	#var sp_loc = ShoulderPoint.position
	#camera.look_at(sp_loc,Vector3.UP)
	#camera.position = Vector3(sp_loc.x,sp_loc.y,sp_loc.z + 5)
	
	pass

func Orbit(target,_delta):
	var OrbitPoint = target.get_node("Orbit")
	camera = foundCameraTypes["Orbit"].get_child(0)
	camera.make_current()
	

func Init(obj,mode,world):
	
	#### Find Camera3D 
	#print_debug(world.find_child("Camera3D"))
	
	### Find Types
	for child in obj.get_children():
		if child is Marker3D:
			if child.name in cameraTypes:
				foundCameraTypes[child.name] = child
	if foundCameraTypes:
		print_debug("Found: ",foundCameraTypes)
	else:
		print_debug("No Camera3D types found")
	
	player = obj
	camera = Camera3D.new()
	camera.far = 3000
	
	var env = WorldEnvironment.new()
	if world.get_node("WorldEnviroment"):
		env = world.get_node("WorldEnvironment").get_environment()
	
	camera.set_environment(env)
	match mode:
		"ThirdPerson":
			springarm = SpringArm3D.new()
			player.get_node(mode).add_child(springarm)
			springarm.call_deferred("add_child", camera)
			springarm.spring_length = 5
			springarm.margin = 0.2
		#springarm.set_as_top_level(true)
		"Orbit":
			if "Orbit" in foundCameraTypes:
				foundCameraTypes["Orbit"].add_child(camera)
				camera.position = Vector3(0,4,10)
		"Chase":
			#foundCameraTypes["Chase"].call_deferred("add_child",camera)
			foundCameraTypes["Chase"].add_child(camera)
			camera.position = Vector3(0,4,10)
		_:
			player.call_deferred("add_child",camera)
			camera.position = Vector3(0,4,10)
			
	camera.make_current()
	
	return foundCameraTypes[mode]
