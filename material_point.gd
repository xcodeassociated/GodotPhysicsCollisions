extends Node

var position
var velocity          = Vector3( 0.0, 0.0, 0.0 )
var previous_position = Vector3( 0.0, 0.0, 0.0 )
var gravity           = Vector3( 0.0, 0.0, 0.0 )
var viscosity         = Vector3( 0.0, 0.0, 0.0 )
var zero_tolerance    = 0.00001

var mass      = 1.0
var mu        = 1.0 
var O         = 0.0

var is_static = false
onready var point = $"point"
onready var arrow = $"point/arrow"
onready var arrowhead  = $"point/arrowhead"
onready var arrow2 = $"point/arrow"
onready var arrowhead2  = $"point/arrowhead"
onready var grz = $"../../grz"
onready var label = $"../../label"
onready var ASP = $"point/ASP"
var up = Vector3(0.0,1.0,0.0)
var right = Vector3(1.0,0.0,0.0)
var isPlay = false
var deltaFromPlay = 0
var delta = 0.0

func _ready():
	# setting velocity
	velocity = Vector3(0, 0, 0) 
	velocity = 0.01*Vector3(2*randf()-1.0,randf(),2*randf()-1.0) # random velocity at start
	
	# setting positions
	previous_position = position - velocity * get_physics_process_delta_time()
	point.global_translate(position)
	
	# setting color
	var mat = SpatialMaterial.new()
	mat.albedo_color = Color(randf(),randf(),randf())
	mat.set_metallic(0.0)
	mat.set_specular(0.0)
	point.set_surface_material(0,mat)
	arrow.set_surface_material(0,mat)
	arrowhead.set_surface_material(0,mat)

var iter = 0

func _physics_process(delta):
	if !is_static:
		
		var is_Collisin = false
		var force = force(delta)
		
		#var faces = grz.mesh.get_faces ()
		var faces = grz.faces
		for i in range(0, faces.size(), 3):
			var p1 = faces[i]
			var p2 = faces[i+1]
			var p3 = faces[i+2]
			var v1 = p2 - p1
			var v2 = p3 - p1
			var n = v1.cross(v2)
			var alfa = (-1 * n).dot(p1)
			var distans = (n.dot(position) + alfa) / n.length()
			if distans < 0:
				var normal = n.normalized()
				var velocityPro = ((velocity.dot(normal)) / normal.length_squared()) * normal
				var velocityGrz = ((grz.velocity.dot(normal)) / normal.length_squared()) * normal
				velocity -= (1 + 0.9) * velocityPro - velocityGrz
				var reactForce = ((force.dot(normal)) / normal.length_squared()) * normal
				force -= reactForce
				self.position += normal * 0.1
				is_Collisin = true
						
		if is_Collisin:
			ASP.play()
			isPlay = true
			deltaFromPlay = 0
			euler(delta, force)
		else:
			verlet(delta)
		
		if isPlay && deltaFromPlay > 0.2:
			ASP.stop()
		
		deltaFromPlay += delta

func _process(delta):
	if !is_static:
		point.translation = position
		
		if label.drowState == label.DrowStates.velocity:
			drowVector(velocity)
		if label.drowState == label.DrowStates.force:
			drowVector(gravity)
		if label.drowState == label.DrowStates.none:
			hideVector()
			
		
func drowVector(vector3):
	arrow.visible = true
	arrowhead.visible = true
	arrow.scale = Vector3(0.2,10.0*vector3.length(),0.2)
	arrow.translation = Vector3(0.0,10.0*vector3.length(),0.0)
	arrowhead.translation = Vector3(0.0,20.0*vector3.length(),0.0)
	var axis = up.cross(vector3.normalized())
	var angle = acos(up.dot(vector3.normalized()))
	if axis.length() > 1e-3:
		point.global_rotate(axis.normalized(),angle)
		up = vector3.normalized()
		
func hideVector():
	arrow.visible = false
	arrowhead.visible = false
	
func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )

func euler(delta,f=force(delta)):
	velocity += f * mu * delta
	previous_position = position
	position += velocity * delta

func verlet(delta,f=force(delta)):
	var new_position  = 2 * position - previous_position + f * mu * pow( delta , 2.0 )
	previous_position = position
	position          = new_position
	velocity          = ( position - previous_position ) / delta

# zero gravity
#func force(delta):
#	return gravity
	
func force(delta):
	var distance = position - self.position
	gravity = Vector3(0,-0.1,0)
	if distance.length() > 0.02:
		gravity = -self.mass*distance*pow(distance.length(),-3)
		viscosity = -0.4*self.velocity
	if distance.length() > 10:
		viscosity *= 2
	else:
		gravity *= 10
	return gravity + viscosity 

func radius():
	return self.get_physics_process_delta_time() * self.velocity.length() + zero_tolerance
