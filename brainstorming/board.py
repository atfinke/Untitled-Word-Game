from typing import List, Set, Tuple

from game_dictionary import GameDictionary
from tile import Tile
from tile_placement import TilePlacement
from space import Space


class Board:

    def __init__(self, tile_placements={}, min_x=0, max_x=0, min_y=0, max_y=0):
        self.tile_placements = tile_placements

        self.min_x = min_x
        self.max_x = max_x
        self.min_y = min_y
        self.max_y = max_y

        self.game_dictionary = GameDictionary()

    def new_words_for_tile_placements(self, tile_placements: List[TilePlacement]) -> Tuple[Set[str], List[TilePlacement]]:
        words_to_check = set()
        nearby_tiles = set()

        for tile_placement in tile_placements:
            x = tile_placement.space.x
            y = tile_placement.space.y

            horizontal_tile_placements = self.tiles_left_and_right(tile_placement)
            vertical_tile_placements = self.tiles_above_and_below(tile_placement)

            nearby_tiles = nearby_tiles.union(set(horizontal_tile_placements)).union(vertical_tile_placements)

            horizontal_word = map(lambda x: x.tile.character, horizontal_tile_placements)
            vertical_word = map(lambda x: x.tile.character, vertical_tile_placements)

            if len(horizontal_tile_placements) > 1:
                words_to_check.add(''.join(horizontal_word))
            if len(vertical_tile_placements) > 1:
                words_to_check.add(''.join(vertical_word))

        return (words_to_check, nearby_tiles)

    def is_valid_placement(self, tile_placements: List[TilePlacement]) -> int:
        new_board = Board(tile_placements=self.tile_placements.copy(), min_x=self.min_x, max_x=self.max_x, min_y=self.min_y, max_y=self.max_y)
        try:
            new_board.add_tiles(tile_placements)
            words_to_check, _ = new_board.new_words_for_tile_placements(tile_placements)

            value = 0
            for word in words_to_check:
                if word not in self.game_dictionary.scrabble_words:
                    # print('Invalid: ' + word)
                    return 0
                else:
                    # print('Valid: ' + word)
                    value += self.game_dictionary.scrabble_words[word]
            return value
        except:
            return 0

    def tiles_above_and_below(self, tile_placement):
        x = tile_placement.space.x
        y = tile_placement.space.y
        return self.tiles_top_of_position(x, y) + [tile_placement] + self.tiles_bottom_of_position(x, y)

    def tiles_left_and_right(self, tile_placement):
        x = tile_placement.space.x
        y = tile_placement.space.y
        return self.tiles_left_of_position(x, y) + [tile_placement] + self.tiles_right_of_position(x, y)

    def tiles_left_of_position(self, x, y):
        if (x - 1, y) in self.tile_placements:
            return self.tiles_left_of_position(x - 1, y) + [self.tile_placements[x - 1, y]]
        else:
            return []

    def tiles_right_of_position(self, x, y):
        if (x + 1, y) in self.tile_placements:
            return [self.tile_placements[x + 1, y]] + self.tiles_right_of_position(x + 1, y)
        else:
            return []

    def tiles_top_of_position(self, x, y):
        if (x, y + 1) in self.tile_placements:
            return self.tiles_top_of_position(x, y + 1) + [self.tile_placements[x, y + 1]]
        else:
            return []

    def tiles_bottom_of_position(self, x, y):
        if (x, y - 1) in self.tile_placements:
            return [self.tile_placements[x, y - 1]] + self.tiles_bottom_of_position(x, y - 1)
        else:
            return []

    def add_tiles(self, tile_placements: List[TilePlacement]) -> Tuple[Set[str], List[TilePlacement]]:
        for tile_placement in tile_placements:
            x = tile_placement.space.x
            y = tile_placement.space.y
            self.min_x = min(self.min_x, x)
            self.max_x = max(self.max_x, x)
            self.min_y = min(self.min_y, y)
            self.max_y = max(self.max_y, y)
            if (x, y) in self.tile_placements:
                raise ValueError('{} already at {},{} (cant place {})'.format(self.tile_placements[x, y], x, y, tile_placement.tile.character))
            self.tile_placements[x, y] = tile_placement
        return self.new_words_for_tile_placements(tile_placements)

    # #yikes, doesn't account for a bunch of things, super inefficient
    def spaces_for_characters(self, n):
        if len(self.tile_placements) == 0:
            word_spaces = {}
            spaces = []
            for i in range(0, n):
                spaces.append(Space(i, 0))
                cop = spaces.copy()
                word_spaces[i + 1] = [cop]
            return word_spaces
        else:
            word_spaces = {}

            for tile_placement in self.tile_placements.values():
                horizontal_tile_placements = self.tiles_left_and_right(tile_placement)

                for character_numbers in range(1, n + 1):
                    min_space = horizontal_tile_placements[0].space
                    max_space = horizontal_tile_placements[-1].space
                    for character_split in range(character_numbers + 1):
                        left_num = character_numbers - character_split

                        left_spaces = []
                        skip = False
                        for left in range(left_num):
                            space = Space(min_space.x - left_num + left, min_space.y)
                            if (space.x, space.y) in self.tile_placements:
                                skip = True
                            else:
                                left_spaces.append(space)

                        right_spaces = []
                        for right in range(1, character_split + 1):
                            space = Space(max_space.x + right, min_space.y)
                            if (space.x, space.y) in self.tile_placements:
                                skip = True
                            else:
                                right_spaces.append(space)

                        if skip:
                            continue

                        spaces = word_spaces.get(character_numbers, [])
                        spaces.append(left_spaces + horizontal_tile_placements + right_spaces)
                        word_spaces[character_numbers] = spaces

                vertical_tile_placements = self.tiles_above_and_below(tile_placement)

                for character_numbers in range(1, n + 1):
                    min_space = vertical_tile_placements[0].space
                    max_space = vertical_tile_placements[-1].space
                    for character_split in range(character_numbers + 1):
                        bottom_nums = character_numbers - character_split
                        top_nums = character_split + 1

                        bottom_spaces = []
                        skip = False
                        for bottom in range(1, bottom_nums + 1):
                            space = Space(min_space.x, min_space.y - bottom)
                            if (space.x, space.y) in self.tile_placements:
                                skip = True
                            else:
                                bottom_spaces.append(space)

                        top_spaces = []
                        for top in range(1, top_nums):
                            space = Space(min_space.x, max_space.y + top_nums - top)
                            if (space.x, space.y) in self.tile_placements:
                                skip = True
                            else:
                                top_spaces.append(space)

                        if skip:
                            continue

                        spaces = word_spaces.get(character_numbers, [])
                        spaces.append(top_spaces + vertical_tile_placements + bottom_spaces)
                        word_spaces[character_numbers] = spaces

            return word_spaces

    def __str__(self):
        board = [['-'] * ((self.max_x - self.min_x) + 1) for _ in range(((self.max_y - self.min_y) + 1))]

        board_pad_x = abs(self.min_x)
        board_pad_y = abs(self.min_y)

        for position, tile_placement in self.tile_placements.items():
            padded_x = position[0] + board_pad_x
            padded_y = position[1] + board_pad_y
            board[padded_y][padded_x] = tile_placement.tile.character
        board.reverse()
        return '\n'.join([' '.join([str(c) for c in r]) for r in board])
