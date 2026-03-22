extends Node


# Directions (in rank-file coords)
const D_U := Vector2i(1, 0)
const D_D := Vector2i(-1, 0)
const D_L := Vector2i(0, -1)
const D_R := Vector2i(0, 1)
const D_UL := Vector2i(1, -1)
const D_UR := Vector2i(1, 1)
const D_DL := Vector2i(-1, -1)
const D_DR := Vector2i(-1, 1)
const D_ALL: Array[Vector2i] = [
    D_U, D_D, D_L, D_R,
    D_UL, D_UR, D_DL, D_DR,
]

# Knight offsets
const K_OFF: Array[Vector2i] = [
    Vector2i(1, 2), Vector2i(1, -2), Vector2i(-1, 2), Vector2i(-1, -2),
    Vector2i(2, 1), Vector2i(2, -1), Vector2i(-2, 1), Vector2i(-2, -1),
]


func move_is_legal(from: Board.Coord, to: Board.Coord) -> bool:
    var b := Globals.board
    var fsq := b.square_at_coord(from)
    var fp := fsq.held
    var tsq := b.square_at_coord(to)
    var tp := tsq.held
    var _log_illegal := func(msg: String) -> void:
        print("%s %s -> %s: %s" % [
            Piece.Type.keys()[fp.type],
            Board.Coord.keys()[from],
            Board.Coord.keys()[to],
            msg,
        ])

    if from == to:
        _log_illegal.call("No move")
        return false
    if not fp:
        _log_illegal.call("No piece to move")
        return false
    if fp.color != Globals.current_turn:
        _log_illegal.call("Not that color's turn")
        return false
    if tp and fp.color == tp.color:
        _log_illegal.call("Can't capture same color")
        return false
    if not to in reachable_coords(fp):
        _log_illegal.call("Not reachable by movement rules")
        return false

    return true


func reachable_coords(piece: Piece) -> Array[Board.Coord]:
    var board := Globals.board
    var coords: Array[Vector2i]
    match piece.type:
        Piece.Type.KING:
            coords = _king_reachable_coords(board, piece)
        Piece.Type.QUEEN:
            coords = _queen_reachable_coords(board, piece)
        Piece.Type.BISHOP:
            coords = _bishop_reachable_coords(board, piece)
        Piece.Type.KNIGHT:
            coords = _knight_reachable_coords(board, piece)
        Piece.Type.ROOK:
            coords = _rook_reachable_coords(board, piece)
        Piece.Type.PAWN:
            coords = _pawn_reachable_coords(board, piece)
    var reachable: Array[Board.Coord]
    reachable.assign(coords.map(Board.rf_to_coord))
    return reachable


func _king_reachable_coords(board: Board, piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]
    for dir in D_ALL:
        var npos := Board.coord_to_rf(piece.board_position) + dir
        if _move_result(board, piece, npos) != MoveResult.NO_MOVE:
            coords.append(npos)
    return coords


func _queen_reachable_coords(board: Board, piece: Piece) -> Array[Vector2i]:
    var coords := _bishop_reachable_coords(board, piece)
    coords.append_array(_rook_reachable_coords(board, piece))
    return coords


func _bishop_reachable_coords(board: Board, piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]
    var ppos := Board.coord_to_rf(piece.board_position)
    for dir: Vector2i in [D_UL, D_UR, D_DL, D_DR]:
        for i in range(1, 8):
            var npos := ppos + dir * i
            var result := _move_result(board, piece, npos)
            if result != MoveResult.NO_MOVE:
                coords.append(npos)
            if result != MoveResult.MOVE:
                # Don't consider any farther in this direction
                break
    return coords


func _knight_reachable_coords(board: Board, piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]
    for off in K_OFF:
        var npos := Board.coord_to_rf(piece.board_position) + off
        if _move_result(board, piece, npos):
            coords.append(npos)
    return coords


func _rook_reachable_coords(board: Board, piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]
    for dir: Vector2i in [D_U, D_D, D_L, D_R]:
        for i in range(1, 8):
            var npos := Board.coord_to_rf(piece.board_position) + dir * i
            var result := _move_result(board, piece, npos)
            if result != MoveResult.NO_MOVE:
                coords.append(npos)
            if result != MoveResult.MOVE:
                # Don't consider any farther in this direction
                break
    return coords


func _pawn_reachable_coords(board: Board, piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]

    var rank_dir: int
    if piece.color == Piece.ChessColor.WHITE:
        rank_dir = 1
    else:
        rank_dir = -1

    var prf := Board.coord_to_rf(piece.board_position)
    var next_rank := prf.x + rank_dir
    var pf := prf.y

    var double_advance := Vector2i(next_rank + rank_dir, pf)
    if (
        not piece.ever_moved and
        Board.rf_inside_board(double_advance) and
        not board.piece_at_rf(double_advance)
    ):
        coords.append(double_advance)

    var advance := Vector2i(next_rank, pf)
    if Board.rf_inside_board(advance) and not board.piece_at_rf(advance):
        coords.append(advance)

    var capture_left := Vector2i(next_rank, pf - 1)
    var capture_right := Vector2i(next_rank, pf + 1)
    for npos: Vector2i in [capture_left, capture_right]:
        if Board.rf_inside_board(npos):
            var other_piece := board.piece_at_rf(npos)
            if other_piece and other_piece.color != piece.color:
                coords.append(npos)

    return coords


enum MoveResult {NO_MOVE, MOVE, CAPTURE}
func _move_result(board: Board, piece: Piece, rf: Vector2i) -> MoveResult:
    if Board.rf_inside_board(rf):
        var other_piece := board.piece_at_rf(rf)
        if not other_piece: return MoveResult.MOVE
        if other_piece.color != piece.color: return MoveResult.CAPTURE
    return MoveResult.NO_MOVE
