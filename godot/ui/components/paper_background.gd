class_name PaperBackground
extends ColorRect
## Stationary paper grain: the same sheet under the whole screen, never per paragraph.

const PAPER_SHADER := preload("res://ui/components/paper.gdshader")


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var paper_material := ShaderMaterial.new()
	paper_material.shader = PAPER_SHADER
	material = paper_material
	_update_colors()
	AppTheme.changed.connect(_update_colors)


func _update_colors() -> void:
	(material as ShaderMaterial).set_shader_parameter("paper_color", AppTheme.paper)
	(material as ShaderMaterial).set_shader_parameter("grain_strength", 0.035 if AppTheme.dark else 0.065)
