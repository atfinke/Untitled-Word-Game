from constants import tile_values


class Tile:
    def __init__(self, character):
        self.character = character
        self.value = tile_values[character]

    def __str__(self):
        return '{} ({})'.format(self.character, self.value)

    def __repr__(self):
        return self.__str__()
