extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_steparea_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		animation_player.play("fallingstone")

func disable_collision():
	set_collision_layer_value(1,false)
