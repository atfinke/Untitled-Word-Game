//
//  ContentView.swift
//  word.proto.ui.swiftui
//
//  Created by Andrew Finke on 4/20/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import SwiftUI

struct Tile: View {
   
    @State private var offset = CGSize(width: 20, height: 20)
    @State private var angle = Angle.init(radians: 0)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .foregroundColor(.green)
        .frame(width: 100, height: 100)
        .rotationEffect(angle)
        .offset(offset)
            .gesture(DragGesture()
                .onChanged({ value in
                    self.offset = value.translation
                    self.angle = Angle.init(radians: Double(atan(self.offset.height / self.offset.width)))
                    
//                    self.rotationEffect(angle)
                }))
    }
}

struct ContentView: View {
    
    var tiles = [
        Tile(),
        Tile(),
        Tile()
    ]
    
    var body: some View {
        Group {
            Text("Hello, World!")
            tiles[0].position(x: 100, y: 100)
            tiles[1]
            tiles[2]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
