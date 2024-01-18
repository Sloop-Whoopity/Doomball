extends CharacterBody2D

const SPEED = 100

func _process(delta):
	velocity.x = -1 * SPEED
	move_and_slide()


func _on_area_2d_body_entered(body):
	print("I touched the player")
