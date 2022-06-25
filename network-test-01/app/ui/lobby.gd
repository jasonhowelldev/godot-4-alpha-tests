extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	gamestate.host_game()
	visible = false
	pass # Replace with function body.


func _on_join_pressed():
	gamestate.join_game()
	visible = false
	pass # Replace with function body.
