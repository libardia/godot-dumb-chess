class_name PieceInfo
extends Resource


@export var type: Piece.Type
@export var color: Piece.ChessColor


static func of(t: Piece.Type, c: Piece.ChessColor) -> PieceInfo:
    var pi := PieceInfo.new()
    pi.type = t
    pi.color = c
    return pi


func equals(other: Variant) -> bool:
    # Other is not the same type
    if not other is PieceInfo:
        return false
    # Other references the same object
    elif other == self:
        return true
    # Memberwise equality
    else:
        return other.type == type and other.color == color


# WARN: Fragile on piece scene paths!
func to_scene() -> PackedScene:
    var path := "res://obj/pieces/piece_"
    path += "w" if color == Piece.ChessColor.WHITE else "k"
    match type:
        Piece.Type.KING: path += "k"
        Piece.Type.QUEEN: path += "q"
        Piece.Type.BISHOP: path += "b"
        Piece.Type.KNIGHT: path += "n"
        Piece.Type.ROOK: path += "r"
        Piece.Type.PAWN: path += "p"
    return load(path + ".tscn")
