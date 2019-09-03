extends MeshInstance

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var position = Vector3(0, 0, 0)
var mass = 100.0
const gravityConst = 0.001
const speed = 0.1
onready var materialPoints = $"../"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	
	if Input.is_key_pressed(KEY_UP):
		self.translation += Vector3(speed, 0, 0)
	if Input.is_key_pressed(KEY_DOWN):
		self.translation += Vector3(-speed, 0, 0)
	if Input.is_key_pressed(KEY_LEFT):
		self.translation += Vector3(0, 0, -speed)
	if Input.is_key_pressed(KEY_RIGHT):
		self.translation += Vector3(0, 0, speed)
		
	materialPoints.add_forces()
		
	self.position = self.translation
	
	

