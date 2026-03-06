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

class VectorRF:
    var r: int
    var f: int

    func to_coord() -> Coord:
        var x := f - 1
        var y := 8 - r
        return (8 * y + x) as Coord

    static func from_coord(coord: Coord) -> VectorRF:
        var x := coord % 8
        @warning_ignore("integer_division")
        var y := coord / 8
        var rf := VectorRF.new()
        rf.r = 8 - y
        rf.f = x + 1
        return rf


var _init_setup: Dictionary[Coord, String]
var squares: Array[Square]


func _enter_tree() -> void:
    GameData.board = self


func _ready() -> void:
    var board_squares: GridContainer = %BoardSquares
    squares.assign(board_squares.get_children())
    board_squares.mouse_exited.connect(func() -> void:
        GameData.hovered_square = null
    )
    for i in squares.size():
        var c := i as Coord
        var sq := squares[i]
        sq.board = self
        if sq.held:
            _init_setup[c] = sq.held.scene_file_path
    squares[0].resized.connect(func() -> void:
        GameData.square_size = squares[0].size
    )


func reset_board() -> void:
    for sq in squares:
        if sq.held: sq.held.free()
    for c: Coord in _init_setup.keys():
        squares[c].add_child(load(_init_setup[c]).instantiate())


func move(from: Coord, to: Coord) -> void:
    if MoveLawyer.move_is_legal(from, to):
        var sqf := squares[from]
        var sqt := squares[to]
        if sqt.held:
            sqt.held.free()
        sqf.held.reparent(sqt, false)


func square_at_rf(rf: VectorRF) -> Square:
    return squares[rf.to_coord()]


func square_at_coord(coord: Coord) -> Square:
    return squares[coord]
