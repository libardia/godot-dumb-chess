class_name PieceRect
extends TextureRect


var piece: Piece


static func make(kind: Chess.Kind, player: Chess.Player) -> PieceRect:
    var pr: PieceRect = Constants.Scenes.PIECE_RECT.instantiate()
    pr.piece.kind = kind
    pr.piece.player = player
    pr.texture = Constants.PIECE_TEXTURES[player][kind]
    return pr
