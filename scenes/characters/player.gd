extends CharacterBody2D

#Настройки движения
@export var speed: int = 200
@export var acceleration: float = 0.2
@export var friction: float = 0.18

#Ссылки на узлы
@onready var sprite =$Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.make_current()
	
func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO: 
		velocity = velocity.lerp(input_vector * speed, acceleration)
		
		if input_vector.x != 0:
			sprite.flip_h = input_vector.x < 0
		else:
			velocity = velocity.lerp(Vector2.ZERO, friction)
		move_and_slide()
