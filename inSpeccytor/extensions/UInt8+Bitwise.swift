//
//  UInt8+Bitwise.swift
//  inSpeccytor
//
//  Created by Mike Hall on 24/12/2020.
//

import Foundation
extension UInt8 {
    mutating func clear(bit: Int){
        self = (self & ~(1 << bit))
    }
    
    mutating func set(bit: Int){
        self = (self | (1 << bit))
    }
    
    mutating func set(bit: Int, value: Bool){
        if (value){
            set(bit: bit)
        } else {
            clear(bit: bit)
        }
    }
    
    func twosCompliment() -> UInt8 {
        var comp = ~self &+ 1
        comp.clear(bit: 7)
        return comp
    }
    
//    func pcOffset() -> Int8 {
//        let subtractor = comp.isSet(bit: 7)
//    }
}
