extends Node


enum Kind {KING, QUEEN, BISHOP, KNIGHT, ROOK, PAWN}
enum Player {WHITE, BLACK}
enum File {A, B, C, D, E, F, G, H}


func coord_is_valid(coord: Vector2i) -> bool:
    return (
        0 <= coord.x and coord.x <= 7 and
        0 <= coord.y and coord.y <= 7
    )


func coord_to_index(coord: Vector2i) -> int:
    return coord.y * 8 + coord.x


func index_to_coord(index: int) -> Vector2i:
    @warning_ignore("integer_division")
    return Vector2i(
        index % 8,
        index / 8
    )


func coord_to_rf(coord: Vector2i) -> String:
    return File.keys()[coord.x].to_lower() + str(8 - coord.y)
