extends Node

# scene imports 
@export var boost_scene: PackedScene
@export var debris_scene: PackedScene

# define speed variables
# speed is defined in Main so it can be passed to background
@export var speed := 80.0
@export var min_speed :=40.0
@export var max_speed := 500.0
@export var target_speed := 100.0

# acceleration is the ship's inherent speed stats 
@export var base_acceleration = 5 # if statement when above recovery threshold acceleration is 5
@export var recovery_acceleration = 10  # if statement when below recovery threshold acceleration is 10
@export var recovery_acceleration_threshold_max = 80.0
@export var recovery_acceleration_threshold_min = 40.0 
@export var acceleration_climb_rate = 5

# debris and slowdown
var safe := true
var crash_time := 0.0
@export var crash_recover := 2  # seconds after debris before climb returns

# define sprint
var run_time := 0.0
var sprint_time := 0.0
@export var sprint_length := 8.0   # seconds of a "split"

@onready var stats: Label = $HUD/StatsLabel  # ???

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# test row so you can hit things immediately
	_spawn_at(160, 120, true)
	_spawn_at(240, 120, false)
	_spawn_at(320, 120, true)
	_spawn_at(200, 160, false)
	_spawn_at(280, 160, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	run_time += delta  # run time is equal to the time between frames
	sprint_time += delta  # sprint time is equal to the time between frames
	
	# crash time control
	if crash_time > 0.0:
		crash_time -= delta
		if crash_time <= 0.0:
			safe = true
	
	# Recovery acceleration
	if speed < recovery_acceleration_threshold_max:
		base_acceleration *= 2.0
	speed += base_acceleration * delta
	
	# Base acceleration
	if speed > recovery_acceleration_threshold_max:
		base_acceleration /= 2.0
	speed += base_acceleration * delta
	
	# Reward acceleration (climb rate)
	if safe and speed >= target_speed:
		speed += acceleration_climb_rate * delta
			
	speed = clampf(speed, min_speed, max_speed)

	if sprint_time >= sprint_length:
		_end_sprint()

	if stats:
		stats.text = "SPD %d  TGT %d  RUN %.1f  SPLIT %.1f" % [
			int(speed), int(target_speed),
			("ON" if safe and speed >= target_speed else "off"),
			run_time
		]

func add_speed(amount: float) -> void:
	speed = clampf(speed + amount, min_speed, max_speed) # for boosters and speed growth
	if amount < 0.0:
			safe = false
			crash_time = crash_recover

# Filler func for end sprint, sprints determine health and iterative level generation
func _end_sprint() -> void:
	# performance: above target = good split
	if speed >= target_speed:
		add_speed(6.0)          # climb-on-clean, tiny
	else:
		add_speed(-10.0)        # speed-punish stand-in
	sprint_time = 0.0
	# next pass: spawn a new wave here
	
# spawner
func _spawn_at(x: float, y: float, is_boost: bool) -> void:
	var packed: PackedScene = boost_scene if is_boost else debris_scene
	if packed == null:
		return
	var item := packed.instantiate()
	item.position = Vector2(x, y)
	$SpawnLayer.add_child(item)
