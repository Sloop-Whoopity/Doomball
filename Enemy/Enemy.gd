extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _on_hurtbox_body_entered(body):
	if body is Ball:
		BallManager.emit_signal("enemy_hurt")
