extends Node

signal try_host_game
signal try_join_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func host_game():
	emit_signal('try_host_game')
	pass

func join_game():
	emit_signal('try_join_game')
	pass
