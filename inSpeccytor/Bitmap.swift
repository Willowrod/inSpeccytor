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
    var positions: Dictionary<Int, Int> = Dictionary()
    var attributes: Dictionary<Int, Int> = Dictionary()
    var height: Int {
        pixels.count / width
    }
    
    init(width: Int, height: Int, color: Color) {
        self.width = width
        pixels = Array(repeating: color, count: 49152)
        paper = Array(repeating: Color.white, count: 768)
        ink = Array(repeating: Color.black, count: 768)
        setupPositions()
    }
    
    subscript(x: Int, y: Int) -> Color {
        get { pixels[y * width + x] }
        set { pixels[y * width + x] = newValue }
    }
    
    mutating func setAttributes(bytes: ArraySlice<UInt8>, flashing: Bool){
        var indicator = 0
        bytes.forEach { byte in
            let isFlashing = byte.isSet(bit: 7) && flashing
            let paperValue: Color = byte.paper()
            let inkValue: Color = byte.ink()
            if (isFlashing){
                paper[indicator] = inkValue
                ink[indicator] = paperValue
            } else {
                paper[indicator] = paperValue
                ink[indicator] = inkValue
            }
            indicator += 1
        }
    }
    
    mutating func blit(bytes: ArraySlice<UInt8>){
        var indicator = 16384
        bytes.forEach { byte in
            let position = positions[indicator] ?? 0
            let colPos = attributes[indicator] ?? 0
            let myInk = ink[colPos]
            let myPaper = paper[colPos]
            pixels[position] = byte.isSet(bit: 7) ? myInk : myPaper
            pixels[position + 1] = byte.isSet(bit: 6) ? myInk : myPaper
            pixels[position + 2] = byte.isSet(bit: 5) ? myInk : myPaper
            pixels[position + 3] = byte.isSet(bit: 4) ? myInk : myPaper
            pixels[position + 4] = byte.isSet(bit: 3) ? myInk : myPaper
            pixels[position + 5] = byte.isSet(bit: 2) ? myInk : myPaper
            pixels[position + 6] = byte.isSet(bit: 1) ? myInk : myPaper
            pixels[position + 7] = byte.isSet(bit: 0) ? myInk : myPaper
            indicator += 1
        }
    }
    
    mutating func setupPositions(){
        var x = 0
        var y = 0
        for a in 16384...18431 {
            let position = ((y * 256) + (x * 8))
            positions[a] = position
            let colPos = (((y / 8) * 32) + x)
            attributes[a] = colPos
            x += 1
            if x > 31 {
                x = 0
                y += 8
                if (y > 63) {
                    y -= 63
                }
            }
        }
        x = 0
        y = 0
        for a in 18432...20479 {
            let position = ((y * 256) + (x * 8)) + 16384
            positions[a] = position
            let colPos = ((((y / 8) * 32) + x)) + 256
            attributes[a] = colPos
            x += 1
            if x > 31 {
                x = 0
                y += 8
                if (y > 63) {
                    y -= 63
                }
            }
        }
        x = 0
        y = 0
        for a in 20480...22527 {
            let position = ((y * 256) + (x * 8)) + 32768
            positions[a] = position
            let colPos = ((((y / 8) * 32) + x)) + 512
            attributes[a] = colPos
            x += 1
            if x > 31 {
                x = 0
                y += 8
                if (y > 63) {
                    y -= 63
                }
            }
        }
        print (positions)
    }
    
}
