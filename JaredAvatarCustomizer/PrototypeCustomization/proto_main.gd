extends Node3D

@onready var proto_jared : Node3D = $Podium/ProtoJared/JaredBody
@onready var proto_jared_ears : Node3D = $Podium/ProtoJared/JaredEars
@onready var rotation_slider : HSlider = $Scene/Camera3D/JaredRotationSlider
@onready var proto_jared_mat = proto_jared.get_surface_override_material(0).duplicate(true)

var eye_options : Array[Node]
var mouth_options : Array[Node]
var ear_options : Array[Node]
var ear_meshes : Array[Mesh] = [
	load("res://PrototypeCustomization/Assets/Models/EarOptions/EarOpt1.res"), 
	load("res://PrototypeCustomization/Assets/Models/EarOptions/EarOpt2.res"),
	load("res://PrototypeCustomization/Assets/Models/EarOptions/EarOpt3.res"),
	load("res://PrototypeCustomization/Assets/Models/EarOptions/EarOpt4.res")
]

func _ready() -> void:
	connect_signals()
	
func connect_signals() -> void:
	eye_options = get_tree().get_nodes_in_group("EyeOptions")
	mouth_options = get_tree().get_nodes_in_group("MouthOptions")
	ear_options = get_tree().get_nodes_in_group("EarOptions")
	for child in eye_options:
		child.connect("pressed", _on_eyeoption_button_pressed.bind(child, eye_options.find(child)))
	for child in mouth_options:
		child.connect("pressed", _on_mouthoption_button_pressed.bind(child, mouth_options.find(child)))
	for child in ear_options:
		child.connect("pressed", _on_earoption_button_pressed.bind(child, ear_options.find(child)))
	
		
func _on_eyeoption_button_pressed(_button: Button, button_index : int):
	proto_jared_mat.set_shader_parameter("eye_custom_option", button_index)
	proto_jared.set_surface_override_material(0, proto_jared_mat)
	
func _on_mouthoption_button_pressed(_button: Button, button_index: int):
	proto_jared_mat.set_shader_parameter("mouth_custom_option", button_index)
	proto_jared.set_surface_override_material(0, proto_jared_mat)

func _on_earoption_button_pressed(_button: Button, button_index: int):
	proto_jared_ears.mesh = ear_meshes[button_index]

func _on_jared_rotation_slider_value_changed(value: float) -> void:
	$Podium/ProtoJared.rotation_degrees.y = value


func _on_nose_color_picker_color_changed(color: Color) -> void:
	proto_jared_mat.set_shader_parameter("nose_color", color)
	proto_jared.set_surface_override_material(0, proto_jared_mat)
	proto_jared_ears.set_surface_override_material(0, proto_jared_mat)

func _on_body_color_picker_color_changed(color: Color) -> void:
	proto_jared_mat.set_shader_parameter("body_color", color)
	proto_jared.set_surface_override_material(0, proto_jared_mat)
	proto_jared_ears.set_surface_override_material(0, proto_jared_mat)

func _on_outline_color_picker_color_changed(color: Color) -> void:
	proto_jared_mat.next_pass.albedo_color = color
	proto_jared.set_surface_override_material(0, proto_jared_mat)
	proto_jared_ears.set_surface_override_material(0, proto_jared_mat)


func _on_exit_pressed() -> void:
	get_tree().quit()
