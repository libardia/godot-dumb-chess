class_name Piece
extends TextureRect


enum ChessColor { WHITE, BLACK }
enum Type { KING,  QUEEN, BISHOP, KNIGHT, ROOK, PAWN }


@export var color: ChessColor
@export var type: Type

var board_position: Board.Coord
