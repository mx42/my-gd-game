extends CanvasLayer

static var health_sprite = load("res://assets/gfx/ship.png");
var elapsed := 0;

func set_health(amount):
	for child in $Health/HealthContainer.get_children():
		child.queue_free();
	for i in amount:
		var text_rect = TextureRect.new();
		text_rect.texture = health_sprite;
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP;
		$Health/HealthContainer.add_child(text_rect);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.score = 0;
	var size = get_viewport().get_visible_rect().size;
	$Score.position = Vector2(size[0] / 2, 50);
	$Health.position = Vector2(50, size[1] - 100);
	$TouchButtons/Shoot.position = Vector2(size[0] - 200, size[1] - 200);
	$"TouchButtons/Virtual Joystick".position = Vector2(200, size[1] - 400);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_score_timer_timeout() -> void:
	elapsed += 1;
	if elapsed >= 10:
		Global.enemy_level += 1;
		if Global.enemy_level % 2 == 0 or Global.meteor_base_timer <= 0.1:
			Global.meteor_base_speed += 25;
		else:
			Global.meteor_base_timer -= 0.05;
	Global.score += 1;
	if int(Global.score / 50.0) > Global.ship_level:
		Global.ship_level += 1;
		if Global.ship_level % 2 == 0:
			Global.player_base_speed += 50;
		else:
			Global.player_shoot_cooldown -= 0.05;
		
	$Score.text = str(Global.score);
	$Details/MeteorSpeed.text = "Meteor Speed: " + str(Global.meteor_base_speed);
	$Details/MeteorDelay.text = "Meteor Delay: " + str(Global.meteor_base_timer);
	$Details/ShipSpeed.text = "Ship Speed: " + str(Global.player_base_speed);
	$Details/ShootCooldown.text = "Shoot Cooldown: " + str(Global.player_shoot_cooldown);
