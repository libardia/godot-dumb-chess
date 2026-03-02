class_name Square
extends Container


var held_piece: Piece


func has_piece() -> bool:
    return is_instance_valid(held_piece)


func take_piece() -> Piece:
    var piece := held_piece
    remove_child(held_piece)
    held_piece = null
    return piece


func put_piece(piece: Piece) -> void:
    add_child(piece)
    held_piece = piece


func create_piece(color: PieceData.Side, type: PieceData.Type) -> void:
    held_piece = PieceData.ALL_PIECES[color][type].instantiate()
    add_child(held_piece)
