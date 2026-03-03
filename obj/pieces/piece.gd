class_name Piece
extends TextureRect


@export var color: PieceData.Side
@export var type: PieceData.Type

var square: Square
var _hovering: bool = false


func _ready() -> void:
    gui_input.connect(_on_input)
    mouse_entered.connect(func() -> void: _hovering = true)
    mouse_exited.connect(func() -> void: _hovering = false)


func _on_input(event: InputEvent) -> void:
    if event.is_action_released(&"left_click") and _hovering:
        queue_free()
