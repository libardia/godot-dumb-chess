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
