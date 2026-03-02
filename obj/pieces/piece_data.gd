class_name PieceData


enum Side { WHITE, BLACK }
enum Type { KING, QUEEN, BISHOP, KNIGHT, ROOK, PAWN }

const PIECE_WK = preload("uid://cxoblltukhwdw")
const PIECE_WQ = preload("uid://dx7ya53noxfvs")
const PIECE_WB = preload("uid://byi34hy7uc2ia")
const PIECE_WN = preload("uid://r5g107ajok7b")
const PIECE_WR = preload("uid://dyse4yfvs3wlv")
const PIECE_WP = preload("uid://tnvtvh1iq4t4")
const PIECE_BK = preload("uid://dj4n6m1q6j5nv")
const PIECE_BQ = preload("uid://ctmxdjhh73msb")
const PIECE_BB = preload("uid://bmxk4ij6sl16i")
const PIECE_BN = preload("uid://crdkc6s3nttmm")
const PIECE_BR = preload("uid://bstgtng2vqt7")
const PIECE_BP = preload("uid://clt0l22udswph")
const WHITE_PIECES: Array[PackedScene] = [
    PIECE_WK, PIECE_WQ, PIECE_WB, PIECE_WN, PIECE_WR, PIECE_WP
]
const BLACK_PIECES: Array[PackedScene] = [
    PIECE_BK, PIECE_BQ, PIECE_BB, PIECE_BN, PIECE_BR, PIECE_BP
]
const ALL_PIECES: Array[Array] = [
    WHITE_PIECES, BLACK_PIECES
]
