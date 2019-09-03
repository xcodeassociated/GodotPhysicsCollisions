extends Node

var Nds = []  # węzły
var NUM = 20
var e = 0.0 # wsp. restytucji

var isPlay = false
var deltaFromPlay = 0

var node_object = load("material_point.tscn")
onready var mass_object = $"Mass"
onready var ASP = $"ASP"
onready var sphere = sphere

func _ready():
	create_scene()

func _process(delta):
	pass

func _physics_process(delta):
	
	if isPlay && deltaFromPlay > 0.1:
			ASP.stop()
		
	deltaFromPlay += delta
	
	for i in range(Nds.size()):
		for j in range(i):
			var dist = (Nds[i].position - Nds[j].position)
			if(dist.length() < Nds[i].radius() + Nds[j].radius()):
				print("Collision of pts: ",i," and ",j)
				var n = dist.normalized()
				var vI = Nds[i].velocity
				var vJ = Nds[j].velocity
				var mI = Nds[i].mass
				var mJ = Nds[j].mass
				var vIn = vI.dot(n)
				var vJn = vJ.dot(n)
				var Jdmm = (e + 1)*(vJn-vIn)/(mI+mJ)
				Nds[i].velocity +=  Jdmm*mJ*n - vIn*n
				Nds[j].velocity += -Jdmm*mI*n - vJn*n
				Nds[i].euler(delta)
				Nds[j].euler(delta)
				isPlay = true
				ASP.play()
				
func add_forces():
	for node in Nds:
		var disVector = mass_object.position - node.position
		var force = (mass_object.gravityConst * ((mass_object.mass * node.mass) / max(disVector.length_squared(), 0.01))) * disVector.normalized()
		node.gravity = force

func create_scene():
	# initialize points
	for i in range(NUM):
		var new_node  = node_object.instance()
		var r     = 1.0
		var phi   = 2*PI*randf()
		var theta = -1.5*PI + PI*randf()
		new_node.position = r*Vector3(cos(phi)*sin(theta),cos(theta),sin(phi)*sin(theta))
		Nds.push_back(new_node)
		add_child(new_node)