class TilePlacement:
    def __init__(self, tile, space):
        self.tile = tile
        self.space = space

    def __str__(self):
        return '{} ({})'.format(self.tile.character, self.space)

    def __repr__(self):
        return self.__str__()
