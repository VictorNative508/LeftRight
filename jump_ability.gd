extends Node2D

@onready var message: Label = $Message

func _ready() -> void:
	message.visible = false
	EventController.interaction.connect(_on_interaction)

func _on_interaction(node: Node):
	if node == self:
		self.queue_free()
