extends Node2D


var turn_speed := 200.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("quit"):
		get_tree().quit()


# movement is 
	var dir := 0.0
	if Input.is_action_pressed("moveleft"):
		$ship1_spr.frame = 1
		dir -= 1.0
	if Input.is_action_pressed("moveright"):
		$ship1_spr.frame = 2
		dir += 1.0
	if Input.is_action_just_released("moveleft"):
		$ship1_spr.frame = 0
	if Input.is_action_just_released("moveright"):
		$ship1_spr.frame = 0
		

	position.x += dir * turn_speed * delta
	position.x = clampf(position.x, 40.0, 440.0)
