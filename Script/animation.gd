extends MeshInstance
export(String) var animation_name = ""

func _ready():
	if animation_name != "":
		$AnimationPlayer.play(animation_name)
