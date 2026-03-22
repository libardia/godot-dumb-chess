class_name PieceDragProxy
extends MarginContainer


@onready var texture_rect: TextureRect = %TextureRect

var held: Piece
var original_coord: Board.Coord
var legal_moves: Array[Board.Coord]


func _enter_tree() -> void:
    Globals.piece_drag_proxy = self
    Globals.square_size_changed.connect(func() -> void:
        size = Globals.square_size
    )
    child_entered_tree.connect(func(child: Node) -> void:
        if child is Piece:
            held = child
            original_coord = child.board_position
    )
    child_exiting_tree.connect(func(child: Node) -> void:
        if child is Piece:
            held = null
    )


func _process(_delta: float) -> void:
    global_position = get_global_mouse_position() - size / 2


func pick_up(piece: Piece) -> void:
    # Piece tracking
    piece.visible = false
    held = piece
    original_coord = piece.board_position

    # Highlight legal moves
    legal_moves = MoveLawyer.reachable_coords(piece)
    for m in legal_moves:
        Globals.board.square_at_coord(m).highlight_legal.visible = true

    # Proxy image
    texture_rect.texture = piece.texture


func drop(coord: Board.Coord) -> void:
    # Actually move piece
    if coord != original_coord and coord in legal_moves:
        Globals.board.move(held.board_position, coord)

    # Piece tracking
    held.visible = true
    held = null

    # Unhighlight legal moves
    for m in legal_moves:
        Globals.board.square_at_coord(m).highlight_legal.visible = false
    legal_moves = []

    # Proxy image
    texture_rect.texture = null
