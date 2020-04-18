//
//  Dictionary.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

struct Dictionary {
    
    let root: Node
    
    // MARK: - Initalization -
    
    init(words: [Substring]) {
        let root = Node(isEOW: false)
        
        let queue = OperationQueue()
        let mergeQueue = OperationQueue()
        mergeQueue.maxConcurrentOperationCount = 1
        
        func process(words: [Substring], letter: Character) {
            queue.addOperation {
                let letterRoot = Node(isEOW: false)
                for word in words {
                    let trimmed = word.compactMap({ "\($0)" }).dropFirst()
                    letterRoot.add(values: Array(trimmed))
                }
                mergeQueue.addOperation {
                    root.edges[String(letter)] = letterRoot
                }
            }
        }
        
        var currentLetter: Character = words[0].first!
        var letterWordsToProcess = [Substring]()
        for word in words {
            guard let letter = word.first else { fatalError() }
            
            if currentLetter != letter {
                process(words: letterWordsToProcess, letter: currentLetter)
                letterWordsToProcess = []
                currentLetter = letter
            }
            letterWordsToProcess.append(word)
        }
        process(words: letterWordsToProcess, letter: currentLetter) // Z
        
        queue.waitUntilAllOperationsAreFinished()
        mergeQueue.waitUntilAllOperationsAreFinished()
        
        self.root = root
    }
    
    // MARK: - Helpers -
    
    func isValid(word: String) -> Bool {
        var node = root
        for letter in word {
            if let nextNode = node.edges["\(letter)"] {
                node = nextNode
            } else {
                return false
            }
        }
        return node.isEOW || word.count == 1
    }
    
}
