extends Node2D

@export var scene: PackedScene

func _ready():
	$CanvasLayer/VBoxContainer/Score.text += str(Global.score);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("continue"):
		get_tree().change_scene_to_packed(scene)
