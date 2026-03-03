class_name Square
extends Container

@onready var highlight_hover: Panel = %HighlightHover
@onready var highlight_pressed: Panel = %HighlightPressed

var board: Board
var piece: Piece
var _hovered: bool
var _pressed: bool


func _enter_tree() -> void:
    child_entered_tree.connect(func(child: Node) -> void:
        if child is Piece:
            child.square = self
            piece = child
    )
    child_exiting_tree.connect(func(child: Node) -> void:
        if child is Piece:
            child.square = null
            piece = null
    )


func _ready() -> void:
    gui_input.connect(_track_pressed)
    mouse_entered.connect(_on_hover_change.bind(true))
    mouse_exited.connect(_on_hover_change.bind(false))


func _track_pressed(event: InputEvent) -> void:
    if event.is_action(&"mouse_left"):
        _pressed = event.is_pressed()
        highlight_pressed.visible = _pressed
        # _pressed changed, so refresh hovered
        _on_hover_change(_hovered)

func _on_hover_change(hovered: bool) -> void:
    _hovered = hovered
    highlight_hover.visible = not _pressed and _hovered
