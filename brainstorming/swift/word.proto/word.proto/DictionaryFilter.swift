//
//  DictionaryFilter.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class DictionaryFilter {

    static func filterInvalidWords(words: [Substring]) -> [Substring] {
        var valid = [Substring]()
        for word in words {
            let unique = Set(word)
            var isValid = true
            for chr in unique {
                let count = word.split(separator: chr, omittingEmptySubsequences: false).count - 1
                if count > TileBag.blankTileCount + TileBag.characterTileCounts[chr]! {
                    print("invalid: \(word)")
                    isValid = false
                    break
                }
            }
            if isValid {
                valid.append(word)
            }
        }
        return valid
    }

    static func filterSortAndSave(words: [Substring]) {
        let filtered = DictionaryFilter.filterInvalidWords(words: words)

        var lastLetter: Character?
        var sortedWords = [Character: [Substring]]()
        for word in filtered {
            guard let letter = word.first else { fatalError() }
            if lastLetter != letter {
                print(letter)
                lastLetter = letter
            }
            var arr: [Substring]
            if let existing = sortedWords[letter] {
                arr = existing
            } else {
                arr = [Substring]()
            }
            arr.append(word)
            sortedWords[letter] = arr
        }

        let sortedByCount = sortedWords.sorted(by: { lhs, rhs -> Bool in
            return lhs.value.count > rhs.value.count
        })

        for (key, value) in sortedByCount {
            let resultPath = NSTemporaryDirectory() + "D-\(key).txt"
            try! value.joined(separator: "\n").write(toFile: resultPath, atomically: true, encoding: .utf8)
            print(resultPath)
        }

//        let result = sortedByCount
//            .map { $0.value }
//            .reduce([], +)
//            .joined(separator: "\n")
//        let resultPath = NSTemporaryDirectory() + "filtered_sorted_words.txt"
//        try! result.write(toFile: resultPath, atomically: true, encoding: .utf8)
//        print(resultPath)
    }
}
