from tile import Tile
import random


class TilePile:

    def __init__(self):
        character_counts = {
            'A': 9,
            'B': 2,
            'C': 2,
            'D': 4,
            'E': 12,
            'F': 2,
            'G': 3,
            'H': 2,
            'I': 9,
            'J': 1,
            'K': 1,
            'L': 4,
            'M': 2,
            'N': 6,
            'O': 8,
            'P': 2,
            'Q': 1,
            'R': 6,
            'S': 4,
            'T': 6,
            'U': 4,
            'V': 2,
            'W': 2,
            'X': 1,
            'Y': 2,
            'Z': 1,
            '?': 0  # don't want to deal with this yet
        }

        self.tiles = []
        for character, count in character_counts.items():
            t = [Tile(character)] * count
            self.tiles += t
        random.shuffle(self.tiles)

    def grab(self, n):
        tiles = self.tiles[:n]
        del self.tiles[:n]
        return tiles
