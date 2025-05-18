extends Area2D
class_name Door

var player_count : int = 0

func _input(event):
	if event.is_action_pressed("up") and player_count >= 2:
		print_debug("NEXT LEVEL")
	if event.is_action_pressed("up") and player_count < 2:
		print_debug("CANNOT PASS")

func _on_body_entered(body):
	if body is Player:
		player_count += 1

func _on_body_exited(body):
	if body is Player:
		player_count -= 1
