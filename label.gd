extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
enum DrowStates {
	velocity,
	force,
	none
}

var drowState = DrowStates.velocity

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.text = "Drow Velocity"

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_key_pressed(KEY_A):
		drowState = DrowStates.force
		self.text = "Drow Force"
	if Input.is_key_pressed(KEY_S):
		drowState = DrowStates.velocity
		self.text = "Drow Velocity"
	if Input.is_key_pressed(KEY_D):
		drowState = DrowStates.none
		self.text = "None"
