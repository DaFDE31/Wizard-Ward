extends CharacterBody2D


const SPEED = 300.0
var movingRight = 1
var canSwitch

func _physics_process(delta: float) -> void:
	if !$RayCast2D.is_colliding() and canSwitch:
		movingRight *= -1
		canSwitch = false
	else:
		canSwitch = true
	
	if movingRight < 0:
		velocity.x = SPEED *-1
		$RayCast2D.target_position = Vector2(-270, 250)
	else:
		velocity.x = SPEED
		$RayCast2D.target_position = Vector2(270, 250)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.killPlayer()
