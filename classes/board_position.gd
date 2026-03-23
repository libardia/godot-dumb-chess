class_name BoardPosition


var coord_map: Dictionary[Board.Coord, PieceInfo] = {}
var coord_list: Array[PieceInfo]
var rf_map: Dictionary[Vector2i, PieceInfo] = {}


func _init() -> void:
    coord_list.resize(Board.Coord.size())


func set_coord(coord: Board.Coord, t: Piece.Type, c: Piece.ChessColor) -> void:
    var pi := PieceInfo.of(t, c)
    coord_map[coord] = pi
    coord_list[coord] = pi
    rf_map[Board.coord_to_rf(coord)] = pi


func set_rf(rf: Vector2i, t: Piece.Type, c: Piece.ChessColor) -> void:
    set_coord(Board.rf_to_coord(rf), t, c)


func unset_coord(coord: Board.Coord) -> void:
    coord_map.erase(coord)
    coord_list[coord] = null
    rf_map[Board.coord_to_rf(coord)] = null


func unset_rf(rf: Vector2i) -> void:
    unset_coord(Board.rf_to_coord(rf))


static func make_starting_position() -> BoardPosition:
    var pos := BoardPosition.new()

    # White officers
    pos.set_rf(Vector2i(1, 1), Piece.Type.ROOK, Piece.ChessColor.WHITE)
    pos.set_rf(Vector2i(1, 2), Piece.Type.KNIGHT, Piece.ChessColor.WHITE)
    pos.set_rf(Vector2i(1, 3), Piece.Type.BISHOP, Piece.ChessColor.WHITE)
    pos.set_rf(Vector2i(1, 4), Piece.Type.QUEEN, Piece.ChessColor.WHITE)
    pos.set_rf(Vector2i(1, 5), Piece.Type.KING, Piece.ChessColor.WHITE)
    pos.set_rf(Vector2i(1, 6), Piece.Type.BISHOP, Piece.ChessColor.WHITE)
    pos.set_rf(Vector2i(1, 7), Piece.Type.KNIGHT, Piece.ChessColor.WHITE)
    pos.set_rf(Vector2i(1, 8), Piece.Type.ROOK, Piece.ChessColor.WHITE)

    # White pawns
    for f in range(1, 9):
        pos.set_rf(Vector2i(2, f), Piece.Type.PAWN, Piece.ChessColor.WHITE)

    # Black pawns
    for f in range(1, 9):
        pos.set_rf(Vector2i(7, f), Piece.Type.PAWN, Piece.ChessColor.BLACK)

    # Black officers
    pos.set_rf(Vector2i(8, 1), Piece.Type.ROOK, Piece.ChessColor.BLACK)
    pos.set_rf(Vector2i(8, 2), Piece.Type.KNIGHT, Piece.ChessColor.BLACK)
    pos.set_rf(Vector2i(8, 3), Piece.Type.BISHOP, Piece.ChessColor.BLACK)
    pos.set_rf(Vector2i(8, 4), Piece.Type.QUEEN, Piece.ChessColor.BLACK)
    pos.set_rf(Vector2i(8, 5), Piece.Type.KING, Piece.ChessColor.BLACK)
    pos.set_rf(Vector2i(8, 6), Piece.Type.BISHOP, Piece.ChessColor.BLACK)
    pos.set_rf(Vector2i(8, 7), Piece.Type.KNIGHT, Piece.ChessColor.BLACK)
    pos.set_rf(Vector2i(8, 8), Piece.Type.ROOK, Piece.ChessColor.BLACK)

    return pos
