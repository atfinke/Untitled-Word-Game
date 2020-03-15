from typing import Optional, List, Set, Tuple
from tile_placement import TilePlacement
from tile import Tile
from space import Space

import itertools
import multiprocessing
import random
import traceback

FULLY_OPERATIONAL_BATTLE_STATION = True

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
        placements.append(TilePlacement(tile_to_use, spaces[index]))

    new_word = ''
    space_index = 0
    special_char_count = 0
    for thing in word:
        if isinstance(thing, Space):
            character = placements[space_index].tile.character
            new_word += character
            space_index += 1
            if 'R' in character or 'D' in character:
                special_char_count += 1
        else:
            new_word += thing.tile.character

    invalid = (None, 0, 0, 0)
    if len(new_word) > 3 and new_word not in board.game_dictionary.common_words:
        return invalid

    if new_word not in board.game_dictionary.scrabble_words:
        return invalid

    value, words = board.is_valid_placement(placements)
    if value > 0:
        return (placements, value, len(placements), special_char_count, words)
    else:
        return invalid

def worker_data_creator_worker(worker_data):
    board, tiles, tiles_to_use_count, words_with_tiles_to_use_spaces = worker_data

    new_data = []
    for tiles_to_use in itertools.permutations(tiles, r=tiles_to_use_count):
        for word in words_with_tiles_to_use_spaces:
            new_data.append((board, word, tiles_to_use))
    return new_data

class Player:

    def __init__(self):
        self.tiles = []
        self.face_down_tiles = []

        if FULLY_OPERATIONAL_BATTLE_STATION:
            self.pool = multiprocessing.Pool(processes=20)
            

    def play_word(self, board) -> Optional[List[TilePlacement]]:
        adjusted_tiles = self.tiles

        # don't care enough to write a decent algo, so just don't try and create big words
        if len(self.tiles) > 7:
            new_list = []
            new_list_chars = []
            for tile in self.tiles:
                if len(new_list) > 6:
                    break
                elif new_list_chars.count(tile.character) < 1:
                    new_list.append(tile)
                    new_list_chars.append(tile.character)
            adjusted_tiles = new_list
            print('trimed (bc cpu) {}->{}'.format(len(self.tiles), len(adjusted_tiles)))

        length = len(adjusted_tiles) if FULLY_OPERATIONAL_BATTLE_STATION else min(5, len(adjusted_tiles))
        
        spaces_for_characters = board.spaces_for_characters(length)
        inital_worker_data = []
        for tiles_to_use_count in range(1, length + 1):
            words_with_tiles_to_use_spaces = spaces_for_characters[tiles_to_use_count]
            inital_worker_data.append((board, adjusted_tiles, tiles_to_use_count, words_with_tiles_to_use_spaces))

        results = []
        if FULLY_OPERATIONAL_BATTLE_STATION:
            print('creating worker data')
            worker_data = self.pool.map(worker_data_creator_worker, inital_worker_data)
            worker_data = [j for sub in worker_data for j in sub] 
            worker_data.reverse()
            print('starting worker')
            results = self.pool.map(worker, worker_data)
            print('done')
        else:
            worker_data = []
            for d in inital_worker_data:
                worker_data += worker_data_creator_worker(d)
            worker_data.reverse()
        
            for d in worker_data:
                results.append(worker(d))

        valid = list(filter(lambda x: x[0], results))

        max_placements = None
        if valid:
            no_special = filter(lambda x: x[3] == 0, valid)

            #max_placements, max_placements_value, max_placements_letters, max_placements_special_char_count
            try:
                max_placements, _, _, _, _ = max(no_special, key=lambda x: x[2])
            except:
                max_placements = None

            if not max_placements:
                _, _, _, special_char_count, w = min(valid, key=lambda x: x[3])
                special = filter(lambda x: x[3] == special_char_count, valid)
                max_placements, _, _, _, w = max(special, key=lambda x: x[2])
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