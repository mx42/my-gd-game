extends Node2D

var meteor_scene: PackedScene = load("res://scenes/meteor.tscn");
var laser_scene: PackedScene = load("res://scenes/laser.tscn");

@export var health: int = 3

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	var window_size = get_viewport().get_visible_rect().size;
	
	$Borders/Left/Coll.shape.size.y = window_size[1];
	$Borders/Right/Coll.shape.size.y = window_size[1];
	$Borders/Top/Coll.shape.size.x = window_size[0];
	$Borders/Bot/Coll.shape.size.x = window_size[0];
	
	$Borders/Right.position.x = window_size[0] + 30;
	$Borders/Bot.position.y = window_size[1];

	Global.enemy_level = 0;
	Global.ship_level = 0;
	Global.score = 0;
	Global.meteor_base_speed = 400;
	Global.meteor_base_timer = 0.25;
	Global.player_base_speed = 500;
	Global.player_shoot_cooldown = 0.5;

	for _n in range(4, 15):
		var star = $Stars/base.duplicate();
		$Stars.add_child(star);
		star.global_position = Vector2(
			rng.randi_range(0, window_size[0]),
			rng.randi_range(0, window_size[1]),
		);
		star.speed_scale = rng.randf_range(0.5, 1.5);
		var s = rng.randf_range(0.5, 1.5);
		star.scale = Vector2(s, s);
	get_tree().call_group("ui", "set_health", health);

func _process(_delta: float) -> void:
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn");

func _on_meteor_timer_timeout() -> void:
	$MeteorTimer.wait_time = Global.meteor_base_timer;
	var meteor = meteor_scene.instantiate();
	$Meteors.add_child(meteor);
	meteor.connect("collision", _on_meteor_collision);

func _on_meteor_collision() -> void:
	health -= 1;
	get_tree().call_group("ui", "set_health", health);
	$ShipHit.play();

func _on_player_laser(pos: Vector2) -> void:
	var laser = laser_scene.instantiate();
	$Lasers.add_child(laser);
	laser.position = pos;
