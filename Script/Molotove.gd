extends KinematicBody

var fire = load("res://Scenes/fire.tscn")

func _ready():
	pass 

func _physics_process(delta):
	var velocity = Vector3(0,-10,0)
	move_and_slide(velocity) 
	
	#breaking
	if is_on_floor() or is_on_wall():
		add_child(fire)
		queue_free()
	
func _exit_tree():
	var scene = load("res://Scene/fire.tscn")
	var scene_instance = scene.instance()
	var position = get_translation()
	scene_instance.set_translation(position)
	scene_instance.set_name("fire")
	get_parent().add_child(scene_instance)
	

