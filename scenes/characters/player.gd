extends CharacterBody2D

#Настройки движения
@export var speed: int = 100
@export var acceleration: float = 0.2
@export var friction: float = 0.18

var near_interactive_object: Node = null
var can_interact: bool = false

func _input(event):
	# Проверяем нажатие кнопки взаимодействия (E)
	if event.is_action_pressed("interact") and can_interact and near_interactive_object != null:
		near_interactive_object.interact()
		
# Добавьте эти функции для управления near_interactive_object
func set_near_interactive_object(object: Node, is_near: bool):
	if is_near:
		near_interactive_object = object
		can_interact = true
		print("Можно взаимодействовать с объектом")
	else:
		if near_interactive_object == object:
			near_interactive_object = null
			can_interact = false
			print("Объект недоступен для взаимодействия")

#Ссылки на узлы
@onready var animated_sprite = $AnimatedSprite2D

var last_direction = Vector2.DOWN


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
		last_direction = input_vector
		
		if input_vector.x != 0:
			animated_sprite.flip_h = input_vector.x < 0
			if animated_sprite.sprite_frames.has_animation("walk_right"):
				animated_sprite.play("walk_right")
		elif input_vector.y < 0:
			if animated_sprite.sprite_frames.has_animation("walk_up"):
				animated_sprite.play("walk_up")
		elif input_vector.y > 0:
			if animated_sprite.sprite_frames.has_animation("walk_down"):
				animated_sprite.play("walk_down")
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		if abs(last_direction.x) > abs(last_direction.y):
			if animated_sprite.sprite_frames.has_animation("idle_right"):
				animated_sprite.play("idle_right")
		elif last_direction.y < 0:
			if animated_sprite.sprite_frames.has_animation("idle_up"):
				animated_sprite.play("idle_up")
		elif last_direction.y > 0:
			if animated_sprite.sprite_frames.has_animation("idle_down"):
				animated_sprite.play("idle_down")
		else:
			animated_sprite.stop()
		  
	move_and_slide()
