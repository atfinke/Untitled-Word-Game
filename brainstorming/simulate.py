from typing import Optional, List, Set, Tuple

from board import Board
from tile import Tile
from tile_pile import TilePile
from tile_placement import TilePlacement
from space import Space
import itertools


import time
import multiprocessing
import random
import traceback


def _worker(worker_data):
    try:
        return worker(worker_data)
    except Exception as e:
        print('Caught exception in worker thread (x = %d):' % x)
        traceback.print_exc()

        print()
        raise e

def worker(worker_data):
    board, word, tiles_to_use = worker_data
    
    placements = []
    spaces = [s for s in word if isinstance(s, Space)]
    for index, tile_to_use in enumerate(tiles_to_use):
        try:
            placements.append(TilePlacement(tile_to_use, spaces[index]))
        except:
            print(1)

    new_word = ''
    space_index = 0
    for thing in word:
        if isinstance(thing, Space):
            new_word += placements[space_index].tile.character
            space_index += 1
        else:
            new_word += thing.tile.character

    if new_word not in board.game_dictionary.common_words:
        return (None, 0)

    value = board.is_valid_placement(placements)
    return (placements, value)

class Player:

    def __init__(self):
        self.tiles = []
        self.face_down_tiles = []

    def play_word(self, board) -> Optional[List[TilePlacement]]:
        spaces_for_characters = board.spaces_for_characters(len(self.tiles))

        worker_data = []
        for tiles_to_use_count in range(1, len(self.tiles) + 1):
            words_with_tiles_to_use_spaces = spaces_for_characters[tiles_to_use_count]
            for tiles_to_use in itertools.permutations(self.tiles, r=tiles_to_use_count):
                for word in words_with_tiles_to_use_spaces:
                    worker_data.append((board, word, tiles_to_use))

        worker_data.reverse()
        pool = multiprocessing.Pool(processes=20)
        results = pool.map(worker, worker_data)

        # results = []
        # for d in worker_data:
        #     results.append(worker(d))

        max_placements, max_placements_value = max(results, key=lambda x: x[1])

        if max_placements:
            used_tiles_characters = list(map(lambda x: x.tile.character, max_placements))

            remaining_tiles = []
            for tile in self.tiles:
                if tile.character in used_tiles_characters:
                    del used_tiles_characters[used_tiles_characters.index(tile.character)]
                else:
                    remaining_tiles.append(tile)

            self.tiles = remaining_tiles
            random.shuffle(self.tiles)
        return max_placements

    def add_tiles(self, tiles: List[Tile]):
        self.tiles += tiles

    def add_face_down_tiles(self, tiles: List[Tile]):
        self.face_down_tiles += tiles


class Simulate:

    def __init__(self):

        self._player1 = Player()
        self._player2 = Player()
        self._player3 = Player()
        self._players = [self._player1, self._player2, self._player3]
        self.player_turn = 0

        self.tile_pile = TilePile()
        self.board = Board()

        self.configure_player(self._player1)
        self.configure_player(self._player2)
        self.configure_player(self._player3)

        while True:
            self.add_move()
            print(self.board)
            for i, p in enumerate(self._players):
                print('p{}: {}'.format(i + 1, list(map(lambda x: x.character, p.tiles))))
            print(' ')
            # if self.player_turn == 2:
            #     return

    def configure_player(self, player):
        tiles = self.tile_pile.grab(7)
        player.add_face_down_tiles(tiles)
        tiles = self.tile_pile.grab(7)
        player.add_tiles(tiles)

    def add_move(self):
        player = self._players[self.player_turn]
        placements = player.play_word(self.board)
        self.board.add_tiles(placements)

        player.add_tiles(self.tile_pile.grab(len(placements)))

        self.player_turn += 1
        if self.player_turn > 2:
            self.player_turn = 0


if __name__ == "__main__":
    sim = Simulate()
    sim.add_move()
