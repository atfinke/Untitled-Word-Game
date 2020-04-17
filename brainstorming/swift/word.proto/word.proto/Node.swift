//
//  Node.swift
//  word.proto
//
//  Created by Andrew Finke on 4/15/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class Node {
    static let indent = "    "

    let isEOW: Bool
    var edges = [String: Node]()

    init(isEOW: Bool) {
        self.isEOW = isEOW
    }

    func add(values: [String]) {
        guard let value = values.first else { return }
        let remaining = Array(values.dropFirst())
        if let node = edges[value] {
            node.add(values: remaining)
        } else {
            let node = Node(isEOW: values.count == 1)
            node.add(values: remaining)
            edges[value] = node
        }
    }

    func description(indentLevel: Int) -> String {
        let indent = Array(repeating: Node.indent, count: indentLevel).joined()
        let edgesDescription = edges.sorted(by: { lhs, rhs -> Bool in
            return lhs.key < rhs.key
        }).map({ (key: String, value: Node) -> String in
            let isEOW = value.isEOW ? "T" : "F"
            let node = value.description(indentLevel: indentLevel + 1)
            return indent + "-\(key)): \(isEOW)\n\(node)"
        }).joined()
        return edgesDescription
    }
}
