extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var pivot = $SpringArm3D
@export var mouse_sensibility: float = 0.1

const SPEED = 30.0
const GRAVITY = 80.0
const JUMP_VELOCITY = 40

var initial_pivot_rotation: Vector3
var jump_direction: Vector3 = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	initial_pivot_rotation = pivot.rotation_degrees
	Dialogic.start("dialogo inicial")

func _input(event):
	if Global.is3D and event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensibility))
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sensibility))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta: float) -> void:
	var input_dir := Vector2(Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT"), 0)
	if Global.is3D:
		input_dir.y = Input.get_action_strength("DOWN") - Input.get_action_strength("UP")

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite_3d.play("jump")
		# Capturar la dirección del salto sólo si hay input, si no mantener la actual
		if direction.length() > 0:
			jump_direction = direction

	if is_on_floor():
		jump_direction = Vector3.ZERO
		if direction.length() > 0:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		# Aplica la dirección guardada, incluso si es cero (manteniendo trayectoria)
		if jump_direction != Vector3.ZERO:
			velocity.x = jump_direction.x * SPEED
			velocity.z = jump_direction.z * SPEED
		else:
			# Si no hay dirección guardada, mantiene la velocidad actual sin modificar
			velocity.x = velocity.x
			velocity.z = velocity.z

	velocity.y -= GRAVITY * delta
	move_and_slide()

	if is_on_floor():
		_set_animation()

func _set_animation():
	if not is_on_floor():
		animated_sprite_3d.play("jump")
		return

	if Global.is3D and velocity.z > 0.1 and velocity.length() > 0:
		animated_sprite_3d.play("back")
		return
	if Global.is3D and velocity.z < -0.1 and velocity.length() > 0:
		animated_sprite_3d.play("foward")
		return

	if velocity.x > 0.1:
		animated_sprite_3d.flip_h = false
	elif velocity.x < -0.1:
		animated_sprite_3d.flip_h = true

	if velocity.length() > 0:
		animated_sprite_3d.play("walk")
	else:
		animated_sprite_3d.play("idle")

func _set_static_camera():
	pivot.rotation_degrees = initial_pivot_rotation

func _on_area_3d_body_entered(_body: Node3D) -> void:
	Global.is3D = !Global.is3D
	print(Global.is3D)
	if not Global.is3D:
		_set_static_camera()
