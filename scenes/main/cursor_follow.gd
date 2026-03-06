class_name PieceDragProxy
extends MarginContainer


@onready var texture_rect: TextureRect = %TextureRect

var held: Piece
var original_coord: Board.Coord


func _enter_tree() -> void:
    GameData.cursor_indicator = self
    GameData.square_size_changed.connect(func() -> void:
        size = GameData.square_size
    )
    child_entered_tree.connect(func(child: Node) -> void:
        if child is Piece:
            held = child
            original_coord = child.board_position
    )
    child_exiting_tree.connect(func(child: Node) -> void:
        if child is Piece:
            held = null
    )


func _process(_delta: float) -> void:
    global_position = get_global_mouse_position() - size / 2


func pick_up(piece: Piece) -> void:
    original_coord = piece.board_position
    texture_rect.texture = piece.texture
    piece.visible = false
    held = piece


func drop() -> void:
    texture_rect.texture = null
    held.visible = true
    held = null
