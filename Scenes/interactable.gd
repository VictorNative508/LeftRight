class_name Interactable extends Area2D

@export var label: String

var can_interact: bool = false:
	set = _set_can_interact,
	get = _get_can_interact

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		EventController.interactable.emit(body, label)
		can_interact = true


func _on_body_exited(body: Node) -> void:
	if body is Player:
		EventController.interactable.emit(null, label)
		can_interact = false


func _input(event):
	if event.is_action_pressed("Interact") and can_interact:
		var parent = self.get_parent()
		if parent:
			EventController.interaction.emit(parent)


func _set_can_interact(value: bool) -> void:
	can_interact = value


func _get_can_interact() -> bool:
	return can_interact