extends Area2D

signal  interacted

@export var item_name: String = "Камень"
@export var quantity: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
# Эта функция вызывается, когда тело заходит в область
func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		body.set_near_interactive_object(self, true)
	
# Эта функция вызывается, когда тело выходит из области	
func _on_body_exited(body: Node):
	if body.is_in_group("player"):
		body.set_near_interactive_object(self, false)


func interact():
	print("Подобран: ", item_name, " x", quantity)
	# Здесь может быть логика добавления в инвентарь, воспроизведение звука и т.д.
	emit_signal("interacted")
	queue_free()
