extends CharacterBody2D
class_name Ball 

signal down_attack

@onready var collision_shape = $CollisionShape2D
@onready var hurtbox = $Hurtbox/CollisionShape2D

var random_label: String = "This is the ball's random label"  #This was a test variable.  Not utilized in code currently.  
const CONST_SPEED = 700
var speed: int = 1 #this variable determines the speed of the ball when struck by the player, it multiplies or adds to the speed CONSTANT
#var new_Speed: int 
var direction = Vector2.ZERO
var passes: int = 0  #how many times should the ball bounce between the two players before it returns to normal speed
var frame_movement


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = CONST_SPEED
	#direction.x = -1 * speed
	BallManager.strike.connect(struck_ball)
	BallManager.player_hurt.connect(_on_player_body_entered)
	print("Ball Global Position: ", global_position)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#test_down()
	#frame_movement = speed * delta #this line is extremely important because it makes our speed independent of frames, which is crucial for timing.  
	#without the above line.  Speed is calculated based on how ever many frames it creates to create speed.  
	#If our game is time dependent, then speed needs to be based off of time not frames. 
	pass


func _physics_process(delta):
	if direction:
		velocity = direction * speed
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		
	move_and_slide()
	
		
	
	


#func _on_wall_body_entered(_body):
	#_body.direction.x *= 1 * speed
	#print("That was the wall!")



func _on_player_body_entered():
	#if body is Ball == true:     #This line is necessary to specify that we are only considering the ball as a body.  Not the player character's own collision shape. 
		#body.random_label
		#print(body.random_label)
	speed_check()
	#direction.x = 1 * speed
	print("The ball hit the player")

		
func struck_ball() -> void:
	print("The ball was struck")  
	#set_collision_layer_value(1,false)
	speed = CONST_SPEED * 2
	#Old Code: direction.x = 1 * speed
	passes = 0


func _on_wall_body_entered(body):
	if body is Ball == true:  # this line is necessary for the wall as well because the wall doesn't have a collision shape for its own staticbody2d, it just has a collision shape for the area2d.  This means that right now, the floor is entering the wall's area2d so there are two bodies touching the wall. 
		#The above line is need to specify that the ball is the only body we're looking for.  
		speed_check()
		#body.direction.x = -1 * speed
		print("The ball hit the wall")


func speed_check() -> void:
		if speed > CONST_SPEED and passes <= 2:
			passes = passes + 1
		else:
			speed = CONST_SPEED
			passes = 0
		print("Passes: ", passes)


#Old down attack		
#func test_down() -> void:
	#if Input.is_action_just_pressed("down attack"):
		#print("you just pressed the down attack")
		#BallManager.emit_signal("down_attack")
		#var new_position = global_position.lerp(floorpoint.global_position, speed)  This line and the next are bad code that doesn't work.  
		#global_position = floorpoint.global_position
		#print("Global Position: ", global_position)

