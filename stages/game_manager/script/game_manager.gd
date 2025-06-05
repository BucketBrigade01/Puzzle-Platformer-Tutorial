extends Node
class_name GameManager

@onready var world_2D : Node2D = $World2D
@onready var world_ui : Control = $WorldUI

var current_world_2D_scene : Node2D

func _ready():
	Global.connect("start_level_transition", transition_level)
	change_scene("res://stages/levels/level_1/level_1.tscn")

func change_scene(scene_name : String, delete : bool = true, keep_running : bool = false):
	if current_world_2D_scene != null:
		if delete:
			current_world_2D_scene.queue_free()
		elif keep_running:
			current_world_2D_scene.visible = false
		else:
			world_2D.remove_child(current_world_2D_scene)
	
	var scene_instance = load(scene_name).instantiate()
	world_2D.add_child(scene_instance)
	current_world_2D_scene = scene_instance

func transition_level() -> void:
	print_debug("transition level")
	change_scene(current_world_2D_scene.next_level)
