extends Spatial

const BULLET = preload("res://Scene/Bullet.tscn")

export(NodePath) var PlayerPath  = "" #You must specify this in the inspector!
export(NodePath) var CameraPath  = ""
export(NodePath) var RaycastPath = ""
export(NodePath) var MeshInstancePath  = ""
export(NodePath) var SilhouettePath = ""
export(float) var MovementSpeed = 15
export(float) var Acceleration = 3
export(float) var Deacceleration = 5
export(float) var MaxJump = 19
export(float) var RotationSpeed = 3
export(float) var MaxZoom = 0.5
export(float) var MinZoom = 1.5
export(float) var ZoomSpeed = 2

var Player
var Camera
var MeshInstance
var Silhouette
var BulletPosition
var RayCast 
var InnerGimbal
var Direction = Vector3()
var LastDirection = Vector3()
var CameraRotation
var gravity = -10
var Accelerate = Acceleration
var Movement = Vector3()
var ZoomFactor = 1
var ActualZoom = 1
var Speed = Vector3()
var CurrentVerticalSpeed = Vector3()
var JumpAcceleration = 3
var IsAirborne = false
var Joystick_Deadzone = 0.2
var Mouse_Deadzone = 20
var bullet_cool = 0

enum ROTATION_INPUT{MOUSE, JOYSTICK, MOVE_DIR}


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Player = get_node(PlayerPath)
	Camera = get_node(CameraPath)
	MeshInstance = get_node(MeshInstancePath)
	Silhouette = get_node(SilhouettePath)
	BulletPosition = MeshInstance.get_child(0)
	InnerGimbal =  $InnerGimbal

#Helper math function
func magnitude(vector):
	if typeof(vector) == typeof(Vector2()):
		return sqrt(vector.x*vector.x + vector.y*vector.y)
	elif typeof(vector) == typeof(Vector3()):
		return sqrt(vector.x*vector.x + vector.z*vector.z)

func _process(delta):
	##Shoot
	if (Input.is_action_pressed("shoot")) and bullet_cool <= 0:
		var bullet = BULLET.instance()
		get_node("/root/").add_child(bullet)
		bullet.set_translation(BulletPosition.get_global_transform().origin)
		bullet.direction = BulletPosition.get_global_transform().basis.z
		bullet_cool = 25
	if bullet_cool > 0:
		bullet_cool -= 1
	#Jump
	if (Input.is_action_pressed("jump")) and not IsAirborne:
		CurrentVerticalSpeed = Vector3(0,MaxJump,0)
		IsAirborne = true

func _physics_process(delta):
	#Rotation[Camera]
	CameraRotation = RotationSpeed * delta
	if (Input.is_action_pressed("rotate_left")):
		InnerGimbal.rotate(Vector3.UP, CameraRotation)
	elif (Input.is_action_pressed("rotate_right")):
		InnerGimbal.rotate(Vector3.UP, -CameraRotation)
	
	#Movement
	var CameraTransform = Camera.get_global_transform()
	if(Input.is_action_pressed("move_up")):
		Direction += -CameraTransform.basis[2]
	if(Input.is_action_pressed("move_back")):
		Direction += CameraTransform.basis[2]
	if(Input.is_action_pressed("move_left")):
		Direction += -CameraTransform.basis[0]
	if(Input.is_action_pressed("move_right")):
		Direction += CameraTransform.basis[0]
	Direction.y = 0
	LastDirection = Direction.normalized()
	var MaxSpeed = MovementSpeed * Direction.normalized()
	Accelerate = Deacceleration
	if(Direction.dot(Speed) > 0):
		Accelerate = Acceleration
	Direction = Vector3.ZERO
	Speed = Speed.linear_interpolate(MaxSpeed, delta * Accelerate)
	Movement = Player.transform.basis * (Speed)
	Movement = Speed
	CurrentVerticalSpeed.y += gravity * delta * JumpAcceleration
	Movement += CurrentVerticalSpeed
	Player.move_and_slide(Movement,Vector3.UP)
	if Player.is_on_floor() :
		CurrentVerticalSpeed.y = 0
		IsAirborne = false
	
	#Zoom
	ActualZoom = lerp(ActualZoom, ZoomFactor, delta * ZoomSpeed)
	InnerGimbal.set_scale(Vector3(ActualZoom,ActualZoom,ActualZoom))
