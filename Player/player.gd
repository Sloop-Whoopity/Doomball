extends CharacterBody2D


@export var speed: int = 180
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var hitbox_timer = $Hitbox/Timer
@onready var player_collision_shape = $CollisionShape2D
var attack_type: String 

var static_position #variable used to prevent the player's position from being adjusted due to impact from the ball. 

func _ready() -> void:
	static_position = global_position
	hurtbox.disabled = false  #To enable and disable Collision Node's, you need to set their disabled property to true or false.  
	hitbox.disabled = true

	
func _process(delta):
	global_position = static_position
	straight_attack()
	down_attack()
	upward_attack()


func _physics_process(delta):
	move()
	move_and_slide()


func move() -> void: #All movement related functions did not create sticky glitch
	velocity.x = 0
	if Input.is_action_pressed("move_right") == true:
		velocity.x = speed

	if Input.is_action_pressed("move_left") == true:
		velocity.x = -speed


func _on_hurtbox_body_entered(body):
	if body is Ball:
		print("This hurt the new player")
		BallManager.emit_signal("player_hurt")
		
#Below are actions that the player can take

func straight_attack() -> void:
	if Input.is_action_just_pressed("straight_attack") == true:
		animation_player.play("attack")
		print("You just got knocked the fuck out")
		print("Timer Starting")
		hitbox_timer.start()
		hurtbox.disabled = true
		hitbox.disabled = false
		print("hitbox visible")
		
func down_attack() -> void:
	if Input.is_action_just_pressed("down_attack"):
		animation_player.play("attack")
		print("You just made a downward attack")
		attack_type = "down"
		hitbox_timer.start()
		hurtbox.disabled = true
		hitbox.disabled = false
		print("Downward Hitbox visible")

func upward_attack() -> void:
	if Input.is_action_just_pressed("upward_attack"):
		animation_player.play("attack")
		attack_type = "upward"
		hitbox_timer.start()
		hurtbox.disabled = true
		hitbox.disabled = false
		print("You just made an upward attack")
		

func _on_hitbox_body_entered(body):
	if body is Ball:
		print("I am striking the ball")
		BallManager.emit_signal("strike")
		#BallManager.emit_signal("down_attack")
		match attack_type:
			"down":
				BallManager.emit_signal("down_attack")
				print("This is the match statement for the down attack working")
			"upward":
				BallManager.emit_signal("upward_attack")
				print("This is the match statement for the upward attack")
			_:
				BallManager.emit_signal("straight_attack")
				print("This is the match statement for the straight attack working")
		
		#BallManager.emit_signal("straight_attack")
		#Issue:  When down attack is used, ball is not fast enough to escape touching the hurtbox after its touched the hitbox
		#this means that the trajectory then changes from the floor back to the enemy resulting in a glitch.  
		#Need the ball not to detect another body until after it has entered a new trajectory.  
		#This issue was solved by moving the player's hurtbox and general collision shape backwards during the attack animation.
		

func hit_reset() -> void:
	hitbox.disabled = true
	hurtbox.disabled = false #Code is correct, we need to enable hurtbox after hits otherwise player won't get hit when they miss.  
	attack_type = "" #resets the attack type at the end of every turn.  
	#New issue.  Disabling hurtbox entirely makes the ball sink into player. 
	
	


func _on_hitbox_timer_timeout():
	hit_reset()
	print("I've disabled the hitbox again")
	print("The hurtbox has been re-enabled")


