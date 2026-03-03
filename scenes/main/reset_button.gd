extends Button


@onready var board: Board = %Board


func _ready() -> void:
    pressed.connect(_on_pressed)


func _on_pressed() -> void:
    board.reset_board()
