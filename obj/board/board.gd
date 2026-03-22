class_name Board
extends Container


enum Coord {
    A8, B8, C8, D8, E8, F8, G8, H8,
    A7, B7, C7, D7, E7, F7, G7, H7,
    A6, B6, C6, D6, E6, F6, G6, H6,
    A5, B5, C5, D5, E5, F5, G5, H5,
    A4, B4, C4, D4, E4, F4, G4, H4,
    A3, B3, C3, D3, E3, F3, G3, H3,
    A2, B2, C2, D2, E2, F2, G2, H2,
    A1, B1, C1, D1, E1, F1, G1, H1,
}


var _init_setup: Dictionary[Coord, String]
var squares: Array[Square]


func _enter_tree() -> void:
    Globals.board = self


func _ready() -> void:
    var board_squares: GridContainer = %BoardSquares
    squares.assign(board_squares.get_children())
    board_squares.mouse_exited.connect(func() -> void:
        Globals.hovered_square = null
    )
    for i in squares.size():
        var c := i as Coord
        var sq := squares[i]
        sq.board = self
        if sq.held:
            _init_setup[c] = sq.held.scene_file_path
    squares[0].resized.connect(func() -> void:
        Globals.square_size = squares[0].size
    )


func reset_board() -> void:
    for sq in squares:
        if sq.held: sq.held.free()
    for c: Coord in _init_setup.keys():
        squares[c].add_child(load(_init_setup[c]).instantiate())


func move(from: Coord, to: Coord) -> void:
    var sqf := squares[from]
    var sqt := squares[to]
    if sqt.held:
        sqt.held.free()
    sqf.held.ever_moved = true
    sqf.held.reparent(sqt, false)


func square_at_rf(rf: Vector2i) -> Square:
    return squares[Board.rf_to_coord(rf)]


func square_at_coord(coord: Coord) -> Square:
    return squares[coord]


func piece_at_rf(rf: Vector2i) -> Piece:
    return square_at_rf(rf).held


func piece_at_coord(coord: Coord) -> Piece:
    return square_at_coord(coord).held


static func coord_to_rf(coord: Coord) -> Vector2i:
    @warning_ignore("integer_division")
    return Vector2i(
        8 - (coord / 8),
        (coord % 8) + 1,
    )


static func rf_to_coord(rf: Vector2i) -> Coord:
    # 8(8-x) + (y-1) => 63 - 8x + y
    return (63 - 8*rf.x + rf.y) as Coord


static func rf_inside_board(rf: Vector2i) -> bool:
    return (
        1 <= rf.x and rf.x <= 8 and
        1 <= rf.y and rf.y <= 8
    )
