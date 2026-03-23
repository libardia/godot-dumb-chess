class_name Constants


class Scenes:
    const PIECE_RECT := preload("uid://i315e6bpe0qo")

# Indexed by [player][kind]
const PIECE_TEXTURES: Array[Array] = [
    [
        preload("uid://cxorx7hmqoe1y"), # WK
        preload("uid://djqwcrpimxari"), # WQ
        preload("uid://bqsvpbfldp6uf"), # WB
        preload("uid://id6oubly5xib"),  # WN
        preload("uid://cpubil7l8eyul"), # WR
        preload("uid://bj1egmlmqw81j"), # WP
    ],
    [
        preload("uid://o4ff5cuxgqeb"),  # BK
        preload("uid://cecbjxp4758fi"), # BQ
        preload("uid://bl3fuyqdbsoeo"), # BB
        preload("uid://bu4xjnva52pah"), # BN
        preload("uid://dawwhu0cjjs68"), # BR
        preload("uid://ckphpbtbuu1vo"), # BP
    ]
]
