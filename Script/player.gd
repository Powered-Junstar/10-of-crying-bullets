extends KinematicBody

export(NodePath) var ex_heavyPath = ""
export(NodePath) var ex_policePath = ""
export(NodePath) var ex_demoPath = ""
export(NodePath) var ex_sniperPath = ""

var ex_heavy
var ex_police
var ex_demo
var ex_sniper

var current_class = "heavy"
var current_ex
var last_class = "heavy"
var last_ex

func _ready():
	ex_heavy = get_node(ex_heavyPath)
	ex_police = get_node(ex_policePath)
	ex_demo = get_node(ex_demoPath)
	ex_sniper = get_node(ex_sniperPath)
	
	current_ex = ex_heavy
	last_ex = ex_heavy
	
func _process(delta):
	
	#select class
	if (Input.is_action_just_pressed("select_1")):
		last_class = current_class
		last_ex = current_ex
		current_class = "heavy"
		current_ex = ex_heavy
		Global.current_class = current_class
	elif(Input.is_action_just_pressed("select_2")):
		last_class = current_class
		last_ex = current_ex
		current_class = "police"
		current_ex = ex_police
		Global.current_class = current_class
	elif(Input.is_action_just_pressed("select_3")):
		last_class = current_class
		last_ex = current_ex
		current_class = "demo"
		current_ex = ex_demo
		Global.current_class = current_class
	elif(Input.is_action_just_pressed("select_4")):
		last_class = current_class
		last_ex = current_ex
		current_class = "sniper"
		current_ex = ex_sniper
		Global.current_class = current_class
	last_ex.hide()
	current_ex.show()
		
	
	#set rotate
	var player_rotate = Global.player_rotate + $Controller/InnerGimbal.rotation_degrees.y + 90
	$body.rotation_degrees.y = player_rotate
	#$body_silhouette.rotation_degrees.y = player_rotate	
	#restart 
	if (translation.y < -90) or (Input.is_action_just_pressed("restart")):
		 get_tree().reload_current_scene()
		
		
		
