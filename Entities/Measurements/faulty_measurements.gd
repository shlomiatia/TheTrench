class_name FaultyMeasurements extends HFlowContainer

@export var battery: int = 1000
@export var oxyxen: int = 1000

@onready var battery_label: Label = $Battery/Value
@onready var oxyxen_label: Label = $Oxygen/Value

@onready var submarine: Submarine = $/root/Game/Submarine

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    battery = min(battery, floor(1000 - submarine.global_position.y / 10950 / 4 * 137))
    if submarine.global_position.y > 3500 * 4:
        oxyxen = 999
    elif submarine.global_position.y > 7000 * 4:
        oxyxen = 998
    @warning_ignore("integer_division")
    battery_label.text = "%s.%s" % [battery / 10, battery % 10] + "%"
    @warning_ignore("integer_division")
    oxyxen_label.text = "%s.%s" % [oxyxen / 10, oxyxen % 10] + "%"
