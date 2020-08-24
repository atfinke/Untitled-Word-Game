//
//  Node.swift
//  word.proto
//
//  Created by Andrew Finke on 4/15/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class Node {
   
    // MARK: - Properties -
    
    private static let indent = "    "
    let isEOW: Bool
    var edges = [UInt8: Node]()

    // MARK: - Initalization -
    
    init(isEOW: Bool) {
        self.isEOW = isEOW
    }
    
    // MARK: - Helpers -

    /// Called 100,000+ times, needs to be as fast as possible
    func add(values: ArraySlice<UInt8>) {
        guard let value = values.first else { return }
        let remaining = values.dropFirst()
        if let node = edges[value] {
            node.add(values: remaining)
        } else {
            let node = Node(isEOW: remaining.isEmpty)
            if !remaining.isEmpty {
                node.add(values: remaining)
            }
            edges[value] = node
        }
    }

    func description(indentLevel: Int) -> String {
        let indent = Array(repeating: Node.indent, count: indentLevel).joined()
        let edgesDescription = edges.map({ (key: UInt8, value: Node) -> String in
            let isEOW = value.isEOW ? "T" : "F"
            let node = value.description(indentLevel: indentLevel + 1)
            return indent + "-\(String(bytes: [key], encoding: .utf8)!): \(isEOW)\n\(node)"
        }).joined()
        return edgesDescription
    }
}
