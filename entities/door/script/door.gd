extends Area2D
class_name Door

@onready var animation_sprite : AnimatedSprite2D = $AnimatedSprite2D

var player_count : int = 0

func _ready():
	Global.connect("player_faded", close_door)

func _input(event):
	if event.is_action_pressed("up") and player_count >= 2:
		animation_sprite.play("open")
	if event.is_action_pressed("up") and player_count < 2:
		print_debug("CANNOT PASS")

func close_door() -> void:
	animation_sprite.play("close")

func _on_body_entered(body):
	if body is Player:
		player_count += 1

func _on_body_exited(body):
	if body is Player:
		player_count -= 1

func _on_animated_sprite_2d_animation_finished():
	if animation_sprite.animation == "open":
		Global.emit_signal("door_opened")
	if animation_sprite.animation == "close":
		Global.emit_signal("start_level_transition")
	
