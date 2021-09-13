extends Node2D

class_name Episode

var complete:bool = false
export(float) var duration:float = 40.0
export(String) var episode:String = "Inside the Machine"


func _ready():
	yield(get_tree().create_timer(1), "timeout")
	visible = true
