extends CharacterBody2D

#@export var SPEED: int = 500;
#@export var SHOOT_COOLDOWN: float = 0.5;

var cooldown := 0.0;
var last_direction := Vector2(0., 0.);
@export var last_direction_coef := 1.2;
@export var max_last_direction := -1.5;

signal laser(pos: Vector2);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window_size = get_viewport().get_visible_rect().size;
	position = Vector2(window_size[0] / 2, window_size[1] / 4 * 3);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed = Global.player_base_speed;
	var direction = Input.get_vector("left", "right", "up", "down");
	velocity = (last_direction + direction) * speed;
	last_direction = (last_direction + direction) / last_direction_coef;
	if last_direction.x < -max_last_direction:
		last_direction.x = -max_last_direction;
	if last_direction.y < -max_last_direction:
		last_direction.y = -max_last_direction;
	if last_direction.x > max_last_direction:
		last_direction.x = max_last_direction;
	if last_direction.y > max_last_direction:
		last_direction.y = max_last_direction;
	if cooldown > 0:
		cooldown -= delta;
	move_and_slide();
	if Input.is_action_just_pressed("fire") and cooldown <= 0:
		laser.emit($LaserStart.global_position)
		cooldown = Global.player_shoot_cooldown;
		$LaserSound.play()
