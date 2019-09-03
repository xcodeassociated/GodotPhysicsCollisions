extends MeshInstance

var faces = []

var position
var velocity          = Vector3( 0.0, 0.0, 0.0 )
var previous_position = Vector3( 0.0, 0.0, 0.0 )
var gravity           = Vector3( 0.0, 0.0, 0.0 )
var viscosity         = Vector3( 0.0, 0.0, 0.0 )
var sumDelata         = 2.0
var baseForce         = Vector3( 0.0, 0.0, 0.0 )

var mass = 1.0
var mu = 0.0
var delta = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_mass(1.0)
	velocity = Vector3(0, 0, 0)
	position = self.translation
	previous_position = position - velocity * get_physics_process_delta_time()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_key_pressed(KEY_Q):
		self.translation = Vector3(0, 0, 0)
		self.position = Vector3(0, 0, 0)
		self.baseForce = Vector3(0, 0, 0)
	if Input.is_key_pressed(KEY_W):
		self.translation = Vector3(0, 0, 0)
		self.position = Vector3(0, 0, 0)
		self.baseForce = Vector3(0.2, 0, 0)
	
	self.translation = self.position
	var facesLocal = self.mesh.get_faces ()
	var facesGlobal = []
	for facesL in facesLocal:
		facesGlobal.append(facesL + self.translation)
	self.faces = facesGlobal
	
func _physics_process(delta):
	euler(delta)
	
func euler(delta,f=force(delta)):
	velocity += f * mu * delta
	previous_position = position
	position += velocity * delta

func verlet(delta,f=force(delta)):
	var new_position  = 2 * position - previous_position + f * mu * pow( delta , 2.0 )
	previous_position = position
	position          = new_position
	velocity          = ( position - previous_position ) / delta
	
func force(delta):
	self.sumDelata += delta
	if self.sumDelata >= 4.0:
		self.sumDelata = 0
		self.velocity = Vector3(0, 0, 0)
		self.baseForce = self.baseForce * -1
	return self.baseForce
	
func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )