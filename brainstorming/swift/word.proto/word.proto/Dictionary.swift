//
//  Dictionary.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

struct Dictionary {
    
    // MARK: - Properties -

    let root: Node

    // MARK: - Initalization -

    init() {
        let date = Date()
        
        let root = Node(isEOW: false)

        let letterQueue = OperationQueue()
        letterQueue.qualityOfService = .utility
        let mergeQueue = OperationQueue()
        mergeQueue.maxConcurrentOperationCount = 1

        let delimiter = UInt8(UnicodeScalar("\n").value)
        
        // sorted by file size
        for letter in "SCPARDMBTIEFHOUGLNWVKJQZYX" {
            let fileName = "D-\(letter)"
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "txt") else { fatalError() }
            
            letterQueue.addOperation  {
                Thread.current.name = "Dictionary Init: \(letter)"

                guard let value = letter.unicodeScalars.first?.value,
                    let words = try? Data(contentsOf: url).split(separator: delimiter) else { fatalError() }
                
                let letterRoot = Node(isEOW: false)
                for wordData in words {
                    let values = [UInt8](wordData)
                    let trimmed = values.dropFirst()
                    letterRoot.add(values: trimmed)
                }
                
                mergeQueue.addOperation {
                    root.edges[UInt8(value)] = letterRoot
                }
            }
        }

        letterQueue.waitUntilAllOperationsAreFinished()
        mergeQueue.waitUntilAllOperationsAreFinished()
        print(-date.timeIntervalSinceNow)
        self.root = root
    }

    // MARK: - Helpers -

    func isValid(word: [UInt8]) -> Bool {
        var node = root
        for letter in word {
            if let nextNode = node.edges[letter] {
                node = nextNode
            } else {
                return false
            }
        }
        return node.isEOW || word.count == 1
    }

}
