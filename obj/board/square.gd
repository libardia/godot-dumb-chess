class_name Square
extends Container


@onready var highlight_hover: Panel = %HighlightHover
@onready var highlight_pressed: Panel = %HighlightPressed

var coord: Board.Coord
var board: Board
var held: Piece
var _hovered: bool
var _pressed: bool


func _enter_tree() -> void:
    coord = Board.Coord[name]
    child_entered_tree.connect(func(child: Node) -> void:
        if child is Piece:
            held = child
            held.board_position = coord
    )
    child_exiting_tree.connect(func(child: Node) -> void:
        if child is Piece:
            held = null
    )


func _ready() -> void:
    gui_input.connect(_on_gui_input)
    mouse_entered.connect(_on_hover_change.bind(true))
    mouse_exited.connect(_on_hover_change.bind(false))


func _on_gui_input(event: InputEvent) -> void:
    if event.is_action(&"mouse_left"):
        _pressed = event.is_pressed()
        highlight_pressed.visible = _pressed
        _on_hover_change(_hovered)
        var cf := BoardData.cursor_follow
        if _pressed:
            if not cf.held and held:
                cf.pick_up(held)
        elif cf.held:
            var hsq := BoardData.hovered_square
            if hsq:
                board.move(cf.original_coord, hsq.coord)
            cf.drop()


func _on_hover_change(hovered: bool) -> void:
    _hovered = hovered
    if hovered: BoardData.hovered_square = self
    highlight_hover.visible = not _pressed and _hovered
