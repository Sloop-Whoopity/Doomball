extends CharacterBody2D


@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var timer = $Hitbox/Timer

const GRAVITY = 200
@export var speed: int = 180




#var direction = Vector2.ZERO
#var random_label: String = "This is random bullshit"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	hurtbox.disabled = false  #To enable and disable Collision Node's, you need to set their disabled property to true or false.  
	hitbox.disabled = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hit()

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var motion = velocity * delta
	move_and_collide(motion)
	move()
	move_and_slide()

func hit() -> void:
	if Input.is_action_just_pressed("hit") == true:
		animation_player.play("hit")
		print("You just got knocked the fuck out")
		print("Timer Starting")
		timer.start()
		hurtbox.disabled = true
		hitbox.disabled = false
		print("hitbox visible")
		
func hit_reset() -> void:
	hitbox.disabled = true
	hurtbox.disabled = false
	print("The hurtbox has been re-enabled")
	print("Global Position: ", global_position)
	
		
func bounce_attack() -> void:
	pass
		
		
func move() -> void:
	velocity.x = 0
	if Input.is_action_pressed("move_right") == true:
		velocity.x = speed

	if Input.is_action_pressed("move_left") == true:
		velocity.x = -speed

	#else:
		#velocity.x = 0
		
	



func _on_timer_timeout():
	hit_reset()


func _on_hitbox_body_entered(body):
	if body is Ball:
		print("I am striking the ball")
		BallManager.strike.emit()
		


func _on_hurtbox_body_entered(body):
	if body is Ball:
		print("Ouch!, that hit the player!")
		BallManager.player_hurt.emit()
