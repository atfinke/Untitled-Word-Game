import pickle
from constants import tile_values


class GameDictionary:

    def __init__(self):

        scrabble_words_name = 'scrabble_words.pickle'
        try:
            with open(scrabble_words_name, 'rb') as handle:
                self.scrabble_words = pickle.load(handle)
        except:
            with open('scrabble_words.txt', 'r') as handle:
                scrabble_words = [w.upper() for w in handle.read().split('\n')]

                self.scrabble_words = {}
                for word in scrabble_words:
                    value = 0
                    for letter in word:
                        value += tile_values[letter]
                    self.scrabble_words[word] = value

                with open(scrabble_words_name, 'wb') as handle:
                    pickle.dump(self.scrabble_words, handle)

        common_words_name = 'common_words.pickle'
        try:
            with open(common_words_name, 'rb') as handle:
                self.common_words = pickle.load(handle)
        except:
            with open('common_words.txt', 'r') as handle:
                common_words = [w.upper() for w in handle.read().split('\n')]
                self.common_words = set([w for w in common_words if w in self.scrabble_words])
                with open(common_words_name, 'wb') as handle:
                    pickle.dump(self.common_words, handle)

        self.common_sorted_words = sorted(self.common_words, key=len)


if __name__ == '__main__':
    game_dict = GameDictionary()
    print(len(game_dict.scrabble_words))
    print(len(game_dict.common_words))
