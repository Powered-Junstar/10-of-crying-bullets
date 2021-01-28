extends Control

export(NodePath) var weapon_texture

var weapon

var gun_heavyPic = ""
var gun_policePic = ""
var gun_demoPic = ""
var gun_sniperPic = ""

func _ready():
	weapon = get_node(weapon_texture)
	
	gun_heavyPic = load("res://files/gun_heavy.png")
	gun_policePic = load("res://files/gun_police.png")
	gun_demoPic = load("res://files/gun_demo.png")
	gun_sniperPic = load("res://files/gun_sniper.png")
	
func _process(delta):
	
	#class
	var _class = Global.current_class
	match _class:
		"heavy":
			weapon.texture = gun_heavyPic
		"police":
			weapon.texture = gun_policePic
		"demo":
			weapon.texture = gun_demoPic
		"sniper":
			weapon.texture = gun_sniperPic
	
	var global_position = Vector2(get_viewport_rect().size.x /2,get_viewport_rect().size.y/2)
	var look_vec = get_global_mouse_position() - global_position
	var global_rotation = atan2(look_vec.y, look_vec.x)*60
	Global.player_rotate = -global_rotation
	
