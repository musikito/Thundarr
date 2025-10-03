extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_velocity : float = -150.0
@export var double_jump_velocity : float = -100.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var has_double_jump : bool = false
var animation_locked : bool = false
#var direction : float = 0.0  # Changed from Vector2 to float
var direction : Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		has_double_jump = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump
			velocity.y = jump_velocity
		elif not has_double_jump:
			# Perform double jump
			velocity.y = double_jump_velocity
			has_double_jump = true

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("left", "right", "up","down")
	#direction = Input.get_axis("left", "right", "up","down")
	if direction:
		#velocity.x = direction * speed
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()  
	change_anim_direction()


func update_animation():
	if not animation_locked:
		if direction.x != 0.0:  # Compare to 0.0 instead of Vector2.ZERO
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
		
		## Flip the sprite based on direction
		#if direction.x > 0:
			#animated_sprite.flip_h = false
		#elif direction.x < 0:
			#animated_sprite.flip_h = true

func change_anim_direction():
	# Flip the sprite based on direction
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
	
