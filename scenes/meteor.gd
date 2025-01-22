extends Area2D

@export var direction := 0.;
@export var speed := 400;
@export var rot_speed := 0.;

var can_collide := true;

signal collision

func _ready() -> void:
	var rng := RandomNumberGenerator.new();
	var width = get_viewport().get_visible_rect().size[0]
	var rand_x = rng.randi_range(10, width - 10);
	var rand_y = rng.randi_range(-150, -50);
	position = Vector2(rand_x, rand_y);
	speed = rng.randi_range(Global.meteor_base_speed - 200, Global.meteor_base_speed + 200);
	rot_speed = rng.randi_range(0, 100);
	direction = rng.randf_range(-1., 1.);

func _process(delta) -> void:
	position += Vector2(direction, 1.0) * speed * delta;
	rotation += rot_speed * delta;
	var height = get_viewport().get_visible_rect().size[1]

	if position.y > height:
		queue_free();

func _on_body_entered(_body: Node2D) -> void:
	if can_collide:
		collision.emit();

func _on_area_entered(area: Area2D) -> void:
	area.queue_free();
	$DestroyMeteor.play();
	Global.score += 10;
	$MeteorImage.hide();
	can_collide = false;
	await get_tree().create_timer(0.5).timeout;
	queue_free();
