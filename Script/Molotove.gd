extends KinematicBody

export var gravity = -1
export var speed = 2

var fire = load("res://Scene/fire.tscn")
var velocity = Vector3()
var direction = Vector3()

func _ready():
	pass

func _physics_process(delta):
	#fall
	velocity.y += gravity * delta
	
	#throw
	var motion =  (direction * speed) + velocity
	translate(motion)
	move_and_slide(Vector3())

	#breaking
	if is_on_floor() or is_on_wall():
		$molotov_sfx.play()
		velocity.y = 0
		var _fire = fire.instance()
		add_child(_fire)
		queue_free()
		
#when breaking
func _exit_tree():
	var scene = fire.instance()
	var position = get_translation()
	scene.set_translation(position)
	scene.set_name("fire")
	get_node("/root/").add_child(scene)
	yield($molotov_sfx,"finished")
	
