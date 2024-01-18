extends Node2D

@onready var ball = $Ball
@onready var floorpoint = $Floorpoint
@onready var player = $Player
#@onready var player = $NewPlayer
@onready var enemy = $Enemy
@onready var top_point = $TopPoint
var new_position #Old code. trying to have the ball update to a new position.  
var bouncing: bool = false
var struck: bool = false
var moving_to_player: bool = false
var moving_to_enemy: bool = false
var moving_to_floorpoint: bool = false
var moving_to_top_point: bool = false
var moving_to: String = ""

#const SPEED: int = 20
#var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	struck = false
	print("Ball Frame Movement: ", ball.frame_movement)
	print("Player Global Position: ", player.global_position)
	all_flags_false()
	moving_to_player = true
	moving_to = "player"
	BallManager.player_hurt.connect(move_to_enemy)
	BallManager.enemy_hurt.connect(move_to_player)
	BallManager.down_attack.connect(down_attack)
	BallManager.straight_attack.connect(straight_attack)
	BallManager.upward_attack.connect(upward_attack)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_destination(delta)
	enemy_destination(delta)
	floorpoint_destination(delta)
	top_point_destination(delta)
	#movement()
	#ball_bounce()
#This is a test from josh
#this is a second git test from Elijah.



func attack(body) -> void:
	pass



func _on_area_2d_body_entered(body):
	pass


#func floorpoint_destination(delta) -> void:
	#print("Game Scene received down attack signal")
	#print("Floorpoint Global Posiiton: ", floorpoint.global_position)
	#print("Ball Global Position Before Moving: ", ball.global_position)
	#var frame_movement = ball.speed * delta
	##var new_position = ball.global_position.lerp(floorpoint.global_position,frame_movement) 
	#new_position = ball.global_position.move_toward(floorpoint.global_position, frame_movement) #Trying to have the ball smoothly move towards the floorpoint.
	#ball.global_position = new_position
	#bouncing = true
	#Lerp is the function used for linear interpolation in Godot.
	#We are referring to the ball node in the above line.  Not the ball class. 
	


#func _on_hitbox_body_entered(body):
	#body.direction.x = 1 * SPEED
	#print("Body is trying to go in opposite direction")

#Below are functions that determine the ball's destination

func player_destination(delta) -> void:
	#if moving_to_player == true:
	if moving_to == "player":
		var frame_movement = ball.speed * delta
		new_position = ball.global_position.move_toward(player.global_position, frame_movement)
		ball.global_position = new_position
		#print("Game's interpretation of ball speed value: ", ball.speed)  #Used to check if game is doubling speed when ball is hit.  
		
func enemy_destination(delta) -> void:
	#if moving_to_enemy == true:
	if moving_to == "enemy":
		#print("Time to move to enemy")
		var frame_movement = ball.speed * delta
		new_position = ball.global_position.move_toward(enemy.global_position, frame_movement)
		ball.global_position = new_position
		
func floorpoint_destination(delta) -> void:
	#if moving_to_floorpoint == true:
	if moving_to == "floorpoint":
		var frame_movement = ball.speed * delta
		new_position = ball.global_position.move_toward(floorpoint.global_position, frame_movement) #Trying to have the ball smoothly move towards the floorpoint.
		ball.global_position = new_position #You don't need the new_position variable, you could just set ball.global_position = the move_toward position
		print("New Ball Position: ", ball.global_position)
	if ball.global_position == floorpoint.global_position: #This is important.  ball.global_position needs to equal the floorpoint.global_position not the new_position variable.  
		print("I've arrived at the floorpoint")
		move_to_enemy()  #This will have to change once the enemy starts attacking.  We will have to 
		#create a new function that describes whether the ball should move_to_enemy() or move_to_player()
	
	
func top_point_destination(delta) -> void:
	#if moving_to_top_point == true:
	if moving_to == "top_point":
		var frame_movement = ball.speed * delta
		new_position = ball.global_position.move_toward(top_point.global_position, frame_movement)
		ball.global_position = new_position
	if ball.global_position == top_point.global_position:
		print("I have arrived at the top_point")
		move_to_enemy()
	
	
	
	
#Below is a currently unnecessary function that may not be needed at all
#func movement(delta) -> void:
	#player_destination(delta)
	##if ball.global_position == player.global_position and struck == false:
		##move_to_enemy()
	#if ball.global_position == enemy.global_position and struck == false:
		#player_destination(delta)
	
#Below are functions that update the flags which tell the ball which direction to go to.  
	
func all_flags_false() -> void:  #Quick function to make all destinations false and set a new one. 
	moving_to_player = false
	moving_to_enemy = false
	moving_to_floorpoint = false
	moving_to_top_point = false
	
func move_to_enemy() -> void:
	#Old Code: ball.global_position = (player.global_position + Vector2(30,0))
	#Unnecessary code: ball.velocity = Vector2.ZERO
	all_flags_false()
	moving_to_enemy = true
	moving_to = "enemy"
	print("I got the signal to move to the enemy")
	

func move_to_player() -> void:
	all_flags_false()
	moving_to_player = true
	moving_to = "player"
	print("I got the signal to move to the player")

func down_attack() -> void:
	all_flags_false()
	moving_to_floorpoint = true
	moving_to = "floorpoint"
	print("I got the signal for the down attack")

func straight_attack() -> void:
	all_flags_false()
	moving_to_player = true
	moving_to = "player"
	print("This was a straight attack")

func upward_attack() -> void:
	all_flags_false()
	moving_to_top_point = true
	moving_to = "top_point"
	print("This was an upward attack")
	


