class_name Cloud extends Sprite2D


func _ready() -> void:
    pass


func _process(delta: float) -> void:
    position.x = position.x + 20.0 * delta
