extends Control

signal started

onready var anim = get_node("AnimationPlayer")
export var floatingMovement : float = 0

var deltaMovement : float = 5


func _ready():
	rect_position = Vector2(get_viewport().size.x/2, get_viewport().size.y/3)

func _input(event):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.onClick()

func onClick():
	if not anim.current_animation == "Dissapear":
		anim.play("Dissapear")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Dissapear":
		emit_signal("started")
		queue_free()
