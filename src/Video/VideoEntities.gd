extends Node2D


var key:bool = false


func _on_Key_enter():
	key = true
	$Key.destroy()


func _on_Chest_action():
	if key:
		$Chest.destroy()
