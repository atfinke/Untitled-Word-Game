from board import Board
from tile import Tile
from space import Space
from tile_placement import TilePlacement

board = Board()
board.add_tiles([
    TilePlacement(Tile("A"), Space(0, 0)),
    TilePlacement(Tile("Y"), Space(1, 0))
])
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("L"), Space(-1, 0))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("M"), Space(-1, 2)),
    TilePlacement(Tile("I"), Space(-1, 1)),
    TilePlacement(Tile("T"), Space(-1, -1))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("H"), Space(0, -1)),
    TilePlacement(Tile("O"), Space(1, -1))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("M"), Space(1, -2))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("Q"), Space(-4, 2)),
    TilePlacement(Tile("U"), Space(-3, 2)),
    TilePlacement(Tile("I"), Space(-2, 2)),
    TilePlacement(Tile("S"), Space(0, 2))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("E"), Space(0, 3))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("U"), Space(-4, 1)),
    TilePlacement(Tile("A"), Space(-4, 0)),
    TilePlacement(Tile("S"), Space(-4, -1)),
    TilePlacement(Tile("H"), Space(-4, -2)),
    TilePlacement(Tile("E"), Space(-4, -3)),
    TilePlacement(Tile("D"), Space(-4, -4)),
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')

tiles = [
    TilePlacement(Tile("J"), Space(-3, 3)),
    TilePlacement(Tile("S"), Space(-3, 1)),
    TilePlacement(Tile("T"), Space(-3, 0))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("F"), Space(-5, 0))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')


tiles = [
    TilePlacement(Tile("N"), Space(-6, -2)),
    TilePlacement(Tile("O"), Space(-5, -2))
]
print(board.is_valid_placement(tiles))
board.add_tiles(tiles)
print(board)
print('\n\n')
