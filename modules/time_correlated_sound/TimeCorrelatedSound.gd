extends AudioStreamPlayer

export(float) var INIT_VOLUME : float = 0.0
export(float) var DESCALE_VELOCITY : float = 30.0
export(float) var DESCALE_TIME : float = 1.0 setget _set_DESCALE_TIME

func play(from_position: float = 0.0):
	.play()
	volume_db = INIT_VOLUME
	$Timer.start()

func _ready():
	_set_DESCALE_TIME(DESCALE_TIME)

func _process(delta : float):
	volume_db -= DESCALE_VELOCITY * delta

func _set_DESCALE_TIME(val : float):
	DESCALE_TIME = val
	if is_inside_tree():
		$Timer.wait_time = DESCALE_TIME

func _on_Timer_timeout():
	stop()
