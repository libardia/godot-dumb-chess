class_name Square
extends Container


var board: Board
var piece: Piece


func _enter_tree() -> void:
    child_entered_tree.connect(func(child: Node) -> void:
        if child is Piece:
            child.square = self
            piece = child
    )
    child_exiting_tree.connect(func(child: Node) -> void:
        if child is Piece:
            child.square = null
            piece = null
    )
