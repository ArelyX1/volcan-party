extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var pivot = $SpringArm3D
@export var mouse_sensibility: float = 0.1

const SPEED = 30.0
const GRAVITY = 80.0
const JUMP_VELOCITY = 40

var initial_pivot_rotation: Vector3
var can_move: bool = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	initial_pivot_rotation = pivot.rotation_degrees
	Dialogic.start("dialogo inicial")

func _input(event):
	if Global.is3D and can_move and event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensibility))
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sensibility))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta: float) -> void:
	if not can_move:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.y -= GRAVITY * delta
		move_and_slide()
		if is_on_floor():
			animated_sprite_3d.play("idle")
		return

	var input_dir := Vector2(Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT"), 0)
	if Global.is3D:
		input_dir.y = Input.get_action_strength("DOWN") - Input.get_action_strength("UP")

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite_3d.play("jump")

	if is_on_floor():
		if direction.length() > 0:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		if direction.length() > 0:
			var air_dir = Vector3(velocity.x, 0, velocity.z).normalized().lerp(direction, 0.3)
			velocity.x = air_dir.x * SPEED
			velocity.z = air_dir.z * SPEED

	velocity.y -= GRAVITY * delta
	move_and_slide()

	if is_on_floor():
		_set_animation()

func _set_animation():
	if not is_on_floor():
		animated_sprite_3d.play("jump")
		return

	if Global.is3D:
		if Input.is_action_pressed("UP"):
			animated_sprite_3d.play("foward")
			return
		if Input.is_action_pressed("DOWN"):
			animated_sprite_3d.play("back")
			return

	if Input.is_action_pressed("LEFT"):
		animated_sprite_3d.flip_h = true
	elif Input.is_action_pressed("RIGHT"):
		animated_sprite_3d.flip_h = false

	if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT") or (Global.is3D and (Input.is_action_pressed("UP") or Input.is_action_pressed("DOWN"))):
		animated_sprite_3d.play("walk")
	else:
		animated_sprite_3d.play("idle")

func _set_static_camera():
	pivot.rotation_degrees = initial_pivot_rotation

func _on_area_3d_body_entered(_body: Node3D) -> void:
	Global.is3D = !Global.is3D
	print(Global.is3D)
	if not Global.is3D:
		pivot.global_rotation_degrees = Vector3.ZERO
		global_rotation_degrees.y = 0
		_set_static_camera()



func _character_entered(body: Node3D) -> void:
	can_move = false
	animated_sprite_3d.play("idle")
	await get_tree().create_timer(10.0).timeout
	can_move = true
