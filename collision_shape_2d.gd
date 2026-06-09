extends Area2D

@export var lastrespawn: Vector2 

func _ready() -> void: 
	pass 

func _on_body_entered(body: Node2D) -> void:
	body.position = lastrespawn

func _process(_delta: float) -> void:
	pass
