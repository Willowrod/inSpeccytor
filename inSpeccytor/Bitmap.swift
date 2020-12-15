//
//  Bitmap.swift
//  inSpeccytor
//
//  Created by Mike Hall on 14/12/2020.
//

import Foundation
struct Bitmap {
    let width: Int
    var pixels: [Color]
    var paper: [Color]
    var ink: [Color]
    
    var height: Int {
        pixels.count / width
    }
    
    init(width: Int, height: Int, color: Color) {
        self.width = width
        pixels = Array(repeating: color, count: width * height)
        paper = Array(repeating: Color.white, count: width * height)
        ink = Array(repeating: Color.black, count: width * height)
    }
    
    
    
    subscript(x: Int, y: Int) -> Color {
        get { pixels[y * width + x] }
        set { pixels[y * width + x] = newValue }
    }
    
    mutating func attributes(byte: Int, x: Int, y: Int, flashing: Bool){
        
        let isFlashing = flashing && byte.isSet(bit: 7)
        
        let paperValue: Color = byte.paper()
        let inkValue: Color = byte.ink()
     //   print ("Attribute at \(x), \(y) has attributes PAPER: \(paperValue) and INK: \(inkValue)")
        for y1 in 0...7 {
        for x1 in 0...7 {
                let position = ((y + y1) * width ) + x + x1
          //      print ("position \(position) has attributes PAPER: \(paperValue) and INK: \(inkValue)"
            if (isFlashing){
                paper[position] = inkValue
                    ink[position] = paperValue
            } else {
            paper[position] = paperValue
                ink[position] = inkValue
            }
            }
        }
    }
    
    mutating func blit(byte: Int, x: Int, y: Int, color: Color){
     //   print ("Plotting byte at \(x), \(y)")
        if byte >= 0 && byte < 256 {
            for a in 0...7 {
                let position = (y * width) + x + 7 - a
                if byte.isSet(bit: a){
                //    print ("position \(position) is SET")
                    pixels[position] = ink[position]
                } else {
             //       print ("position \(position) is OFF")
                    pixels[position] = paper[position]
                }
            }
        }
    }
}
