class_name Board
extends Container


enum ChessCoord {
    A8, B8, C8, D8, E8, F8, G8, H8,
    A7, B7, C7, D7, E7, F7, G7, H7,
    A6, B6, C6, D6, E6, F6, G6, H6,
    A5, B5, C5, D5, E5, F5, G5, H5,
    A4, B4, C4, D4, E4, F4, G4, H4,
    A3, B3, C3, D3, E3, F3, G3, H3,
    A2, B2, C2, D2, E2, F2, G2, H2,
    A1, B1, C1, D1, E1, F1, G1, H1,
}
enum MoveError {
    OK,
    NO_MOVE, CAPTURE_OWN_COLOR
}


var _init_setup: Dictionary[ChessCoord, String]
var squares: Array[Square]


func _ready() -> void:
    squares.assign(%BoardSquares.get_children())
    for i in squares.size():
        var c := i as ChessCoord
        var sq := squares[i]
        sq.board = self
        if sq.piece:
            _init_setup[c] = sq.piece.scene_file_path
    #resized.connect(func() -> void: squares[0].size)


func reset_board() -> void:
    for sq in squares:
        if sq.piece: sq.piece.free()
    for c: ChessCoord in _init_setup.keys():
        squares[c].add_child(load(_init_setup[c]).instantiate())


func move(from: ChessCoord, to: ChessCoord) -> void:
    if move_is_legal(from, to):
        var sqf := squares[from]
        var sqt := squares[to]
        if sqt.piece:
            sqt.piece.free()
        sqf.piece.reparent(sqt, false)


func move_is_legal(from: ChessCoord, to: ChessCoord) -> MoveError:
    var sqf := squares[from]
    var pf := sqf.piece
    var sqt := squares[to]
    var pt := sqt.piece
    if not pf: return MoveError.NO_MOVE
    if pt and pt.color == pf.color: return MoveError.CAPTURE_OWN_COLOR
    #TODO: SO MANY MORE CHECKS
    return MoveError.OK
