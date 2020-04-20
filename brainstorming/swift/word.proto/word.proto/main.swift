//
//  main.swift
//  word.proto
//
//  Created by Andrew Finke on 4/15/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

var gameInitTime = 0.0
var gameMoveTime = 0.0
var dictionaryTime = 0.0
var totalTime = 0.0

var trials = 20.0

for _ in 0..<Int(trials) {

    let date = Date()

    let game = _Game()
    print("game init time: \(-date.timeIntervalSinceNow)")
    gameInitTime += -date.timeIntervalSinceNow

    let trial = Date()
    game.move()
    print("game move time: \(-trial.timeIntervalSinceNow)")
    gameMoveTime += -trial.timeIntervalSinceNow

    let trial2 = Date()
    _ = Dictionary()
    print("dictionary time: \(-trial2.timeIntervalSinceNow)")
    dictionaryTime += -trial2.timeIntervalSinceNow

    totalTime += -date.timeIntervalSinceNow

    print("\n")
}

print("--")
print("gameInitTime: \(gameInitTime / trials)")
print("gameMoveTime: \(gameMoveTime / trials)")
print("dictionaryTime: \(dictionaryTime / trials)")
print("totalTime: \(totalTime / trials)")
print(123)
