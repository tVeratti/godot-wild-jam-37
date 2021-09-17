extends Node2D

class_name Episode

var complete:bool = false
export(float) var duration:float = 40.0
export(bool) var autoplay:bool = true
export(String) var title:String = "Title"
export(String) var episode:String = "Inside the Machine"


func _ready():
	if has_node("FadeIn"):
		$FadeIn.visible = true
	
	yield(get_tree().create_timer(0.1), "timeout")
	visible = true
