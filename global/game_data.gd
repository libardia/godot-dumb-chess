extends Node


signal square_size_changed


var square_size: Vector2:
    set(value):
        square_size = value
        square_size_changed.emit()

var board: Board
var cursor_indicator: PieceDragProxy
var hovered_square: Square
var current_turn := Piece.ChessColor.WHITE
