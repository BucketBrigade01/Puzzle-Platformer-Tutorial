extends Area2D
class_name TopDetectionBox

@export var player : Player

func _on_area_entered(area):
	if area.is_in_group("BottomDetectionBox"):
		# Top Player
		var detected_player : Player = area.owner
		detected_player.current_state = detected_player.StackState.STACKED
		detected_player.partner = player
		detected_player.disable_body_collider(true)
		
		# Bottom Player
		player.current_state = player.StackState.CARRYING
		player.partner = detected_player
		
