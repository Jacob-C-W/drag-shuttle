extends Area2D
@export var kind := "debris"
@export var bump := -28.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var main := get_tree().current_scene
	if main == null or not ("speed" in main):
		return
	position.y += main.speed * delta
	if position.y > 360.0:
		queue_free()

func _on_hit(other: Area2D) -> void:
	if not other.is_in_group("player"):
		return
	var main := get_tree().current_scene
	if kind == "boost":
		main.add_speed(absf(bump))
	else:
		main.add_speed(-absf(bump))
	queue_free()
