extends CharacterBody2D
class_name Player

const SPEED = 300.0
#const SPEED_ACCELERATION = 50.0
const JUMP_FORCE = -400.0
const MAX_JUMP_FUEL = 100.0

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 980.0
var jump_fuel = MAX_JUMP_FUEL
var is_jumping : bool = false

func is_local_authority():
	return $networking/MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

#func _init():
#	# need to set initial position before adding to tree so it is synced to network properly
#

# Called when the node enters the scene tree for the first time.
func _ready():
	# int constructior taking a string is currenty broken
	$networking/MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	$Control/labelplayername.text = str(name)
#	position.x += randf_range(50.0,500.0)
#	position.y += randf_range(50.0,500.0)
	pass # Replace with function body.

func _physics_process(delta):
	if not is_local_authority():
		if not $networking.processed_position:
			position = $networking.sync_position
			$networking.processed_position = true
		velocity = $networking.sync_velocity
		is_jumping = $networking.sync_is_jumping
		
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_pressed("jump") and jump_fuel >= 0:
		velocity.y = JUMP_FORCE
		jump_fuel -= 10
		is_jumping = true
	else:
		is_jumping = false
	
	if is_on_floor():
		jump_fuel = MAX_JUMP_FUEL
	
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	
	move_and_slide()
	
	# update vars that need to be replicated to others
	$networking.sync_position = position
	$networking.sync_velocity = velocity
	$networking.sync_is_jumping = is_jumping


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





