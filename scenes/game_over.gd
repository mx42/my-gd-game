extends Node2D

@export var scene: PackedScene

var delay := 1.5

func _ready():
	$CanvasLayer/VBoxContainer/Score.text += str(Global.score);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delay -= delta;
	if delay <= 0:
		$CanvasLayer/VBoxContainer2/Label.visible = true;
	if Input.is_action_just_pressed("continue") and delay <= 0:
		get_tree().change_scene_to_packed(scene)
