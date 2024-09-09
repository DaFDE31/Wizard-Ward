extends CharacterBody2D


const SPEED = 850.0
const JUMP_VELOCITY = -2000.0
var limiter = 0.1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var runMultiplier
	if Input.is_action_pressed("run"):
		runMultiplier = 3
	else:
		runMultiplier = 1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * runMultiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * runMultiplier)
	if velocity.x < 0 and is_on_floor():
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0 and is_on_floor():
		$AnimatedSprite2D.flip_h = false
	if velocity.x != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
		
		
	if Input.is_action_just_pressed("Magic"):
		var magicNode = load("res://scenes/magic_area.tscn")
		var newMagic = magicNode.instantiate()
		if $AnimatedSprite2D.flip_h == false:
			newMagic.direction = -1
		else:
			newMagic.direction = 1
		newMagic.set_position(%MagicSpawnPoint.global_transform.origin)
		get_parent().add_child(newMagic)
	move_and_slide()

func killPlayer():
	position = %Respawn.position
	$AnimatedSprite2D.flip_h= false
	if GameManager.score >= 200:
		GameManager.score -= 200
	else:
		GameManager.score = 0

func _on_death_body_entered(body: Node2D) -> void:
	killPlayer()
