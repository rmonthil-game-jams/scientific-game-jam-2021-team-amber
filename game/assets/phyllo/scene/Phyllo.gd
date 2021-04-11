extends Spatial

func happy():
	$AnimationPlayer.play("Happy")

func angry():
	$AnimationPlayer.play("Angry")

func speak():
	$AnimationPlayer.play("Speak")

func idle():
	$AnimationPlayer.play("Ilde")
