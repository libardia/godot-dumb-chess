extends Node


func move_is_legal(from: Board.Coord, to: Board.Coord) -> bool:
    var b := GameData.board
    var fsq := b.square_at_coord(from)
    var fp := fsq.held
    var tsq := b.square_at_coord(to)
    var tp := tsq.held

    # no piece to move
    if not fp: return false
    # not that color's turn
    if fp.color != GameData.current_turn: return false
    # can't capture own color
    if fp.color == tp.color: return false

    return true


func reachable_squares(piece: Piece) -> Array[Square]:
    var b := GameData.board
    var coords: Array[Vector2i]
    match piece.type:
        Piece.Type.KING:
            coords = _king_reachable_coords(piece)
        Piece.Type.QUEEN:
            coords = _queen_reachable_coords(piece)
        Piece.Type.BISHOP:
            coords = _bishop_reachable_coords(piece)
        Piece.Type.KNIGHT:
            coords = _knight_reachable_coords(piece)
        Piece.Type.ROOK:
            coords = _rook_reachable_coords(piece)
        Piece.Type.PAWN:
            coords = _pawn_reachable_coords(piece)
    var squares: Array[Square]
    for c in coords:
        if Board.rf_inside_board(c):
            squares.append(b.square_at_rf(c))
    return squares


func _king_reachable_coords(piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]
    for dx: int in [-1, 0, 1]:
        for dy: int in [-1, 0, 1]:
            if dx != 0 and dy != 0:
                var d := Vector2i(dx, dy)
                coords.append(Board.coord_to_rf(piece.board_position) + d)
    return coords


func _queen_reachable_coords(piece: Piece) -> Array[Vector2i]:
    var coords := _bishop_reachable_coords(piece)
    coords.append_array(_rook_reachable_coords(piece))
    return coords


func _bishop_reachable_coords(piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]
    var rf := Board.coord_to_rf(piece.board_position)
    for i in 7:
        coords.append_array([
            Vector2i(rf.x + i, rf.y + i),
            Vector2i(rf.x + i, rf.y - i),
            Vector2i(rf.x - i, rf.y + i),
            Vector2i(rf.x - i, rf.y - i),
        ])
    return coords


func _knight_reachable_coords(piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]
    for dx: int in [-2, -1, 1, 2]:
        var k := 3 - absi(dx)
        for dy: int in [k, -k]:
            var d := Vector2i(dx, dy)
            coords.append(Board.coord_to_rf(piece.board_position) + d)
    return coords


func _rook_reachable_coords(piece: Piece) -> Array[Vector2i]:
    var coords: Array[Vector2i]
    var rf := Board.coord_to_rf(piece.board_position)
    for i in 7:
        coords.append_array([
            Vector2i(rf.x + i, rf.y),
            Vector2i(rf.x - i, rf.y),
            Vector2i(rf.x, rf.y + i),
            Vector2i(rf.x, rf.y - i),
        ])
    return coords


func _pawn_reachable_coords(piece: Piece) -> Array[Vector2i]:
    var rf := Board.coord_to_rf(piece.board_position)
    var c := piece.color
    var coords: Array[Vector2i]

    var color_dir := 1 if c == Piece.ChessColor.WHITE else -1
    var next_rank := rf.y + color_dir
    coords = [
        Vector2i(rf.x + 1, next_rank), # capture to the right
        Vector2i(rf.x, next_rank), # move forward
        Vector2i(rf.x - 1, next_rank), # capture to the left
    ]
    if not piece.ever_moved:
        coords.append(
            Vector2i(rf.x, next_rank + color_dir) # move two forward
        )
    return coords
