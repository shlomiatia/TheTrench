class_name Geometry extends Polygon2D

func _ready():
	update_editor_properties()

func _process(_delta):
	pass

func _notification(what):
	if what == NOTIFICATION_ENTER_TREE:
		update_editor_properties()

func update_editor_properties():
	var collision_shape_2d = $StaticBody2D.get_child(0)
	collision_shape_2d.polygon = polygon
	var light_occluder_2d = $LightOccluder2D
	light_occluder_2d.occluder.polygon = polygon
