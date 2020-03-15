from typing import Optional, List, Set, Tuple

from board import Board
from tile import Tile
from tile_pile import TilePile
from tile_placement import TilePlacement
from space import Space

from sim_player import Player

class Simulate:

    def __init__(self):

        self.tiles_per_player = 5

        self._player1 = Player()
        self._player2 = Player()
        self._player3 = Player()
        self._players = [self._player1, self._player2, self._player3]
        self.player_turn = 0

        self.tile_pile = TilePile()
        self.board = Board()

        # self.board.add_player_tiles([
        #     TilePlacement(Tile("W"), Space(1, 0)),
        #     TilePlacement(Tile("I"), Space(2, 0)),
        #     TilePlacement(Tile("N"), Space(3, 0)),
        #     TilePlacement(Tile("E"), Space(4, 0)),
        # ])

        self.configure_player(self._player1)
        self.configure_player(self._player2)
        self.configure_player(self._player3)

        # self._player1.tiles = [Tile('Q')]
        # self.board.min_word_value = 10
        # print(self.board)

        turns = 0

        self.tile_pile.grab(40)
        
        while True:
            turns += 1
            print('\n\np{} turn: ({})'.format(self.player_turn + 1, turns))
            self.add_move()
            print(self.board)
            for i, p in enumerate(self._players):
                face_str = '[NO FACE DOWN]' if len(p.face_down_tiles) == 0 else ''
                chars = sorted(list(map(lambda x: x.character, p.tiles)))
                print('p{}: {} {}'.format(i + 1, chars, face_str))
            print('tiles left: {}'.format(len(self.tile_pile.tiles)))
            # if self.player_turn == 2:
            #     return

    def configure_player(self, player):
        tiles = self.tile_pile.grab(self.tiles_per_player)
        player.add_face_down_tiles(tiles)
        tiles = self.tile_pile.grab(self.tiles_per_player)
        player.add_tiles(tiles)

    def add_move(self):
        player = self._players[self.player_turn]
        placements = player.play_word(self.board)

        if placements:
            self.board.add_player_tiles(placements)
            tiles_needed = self.tiles_per_player - len(player.tiles)
            if tiles_needed > 0:
                player.add_tiles(self.tile_pile.grab(tiles_needed))

            if len(player.tiles) == 0:
                if len(player.face_down_tiles) == 0:
                    print('game over')
                    exit(0)
                else:
                    player.tiles = player.face_down_tiles
                    player.face_down_tiles = []
        else:
            player.add_tiles(self.board.tiles_for_player_that_failed())

        self.player_turn += 1
        if self.player_turn > 2:
            self.player_turn = 0


if __name__ == "__main__":
    sim = Simulate()
    sim.add_move()
