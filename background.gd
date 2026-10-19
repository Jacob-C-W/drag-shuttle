extends Node2D

var bands: Array[ColorRect] = []
var spacing := 40.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ground := $ground as ColorRect
	for i in 8:
		var r := ColorRect.new()
		r.color = Color(0.55, 0.42, 0.25)
		r.size = Vector2(480, 4)
		r.position = Vector2(0, ground.position.y + i * spacing)
		r.z_index = 1
		add_child(r)
		bands.append(r)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var spd: float = get_parent().speed
	var ground := $ground as ColorRect
	var top := ground.position.y
	var bottom := top + ground.size.y
	for r in bands:
		r.position.y += spd * delta
		if r.position.y > bottom:
			r.position.y -= spacing * bands.size()
