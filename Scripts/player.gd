extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_velocity : float = -150.0
@export var double_jump_velocity : float = -100.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var has_double_jump : bool = false
var animation_locked : bool = false
#var direction : float = 0.0  # Changed from Vector2 to float
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true
	else:
		has_double_jump = false
		
		if was_in_air == true:
			land()
		was_in_air = false
		

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump
			jump()
		elif not has_double_jump:
			# Perform double jump
			#velocity.y = double_jump_velocity
			double_jump()

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("left", "right", "up","down")
	#direction = Input.get_axis("left", "right", "up","down")
	if direction.x !=0 && animated_sprite.animation != "jump_end":
		#velocity.x = direction * speed
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()  
	change_anim_direction()


func update_animation():
	if not animation_locked:
		if not is_on_floor():
			animated_sprite.play("jump_loop")
		else:
			if direction.x != 0.0:  # Compare to 0.0 instead of Vector2.ZERO
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
		
		### Refactor to it's own function
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
	
func jump():
	velocity.y = jump_velocity
	# We call the start of the anim
	animated_sprite.play("jump_start")
	# Lock the anim
	animation_locked = true
	
func double_jump():
	velocity.y = double_jump_velocity
	animated_sprite.play("jump_double")
	animation_locked = true
	has_double_jump = true

func land():
	animated_sprite.play("jump_end")
	# Lock the anim
	animation_locked = true

# Function created from the signal, next to inspector
func _on_animated_sprite_2d_animation_finished() -> void:
	## Refactor to an array of anims
	if(["jump_end", "jump_start","jump_double"].has(animated_sprite.animation)):
		animation_locked = false
	# Check if the anim is "jump_end"
	# then we release the lock
	#if(animated_sprite.animation == "jump_end"):
		# Relese the anim
		#animation_locked = false
	#elif(animated_sprite.animation == "jump_start"):
		# Relese the anim
		#animation_locked = false
