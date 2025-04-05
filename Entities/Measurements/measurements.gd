class_name Measurements extends PanelContainer

@onready var submarine: Submarine = $/root/Game/Submarine
@onready var label: Label = $DepthValue

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    label.text = "%s m" % floor(submarine.global_position.y / 4)
