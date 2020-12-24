//
//  Register.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation

class Register {
    var byteValue: UInt8 = 0
    
    func value() -> UInt8 {
        return byteValue
    }
    
    func hexValue() -> String {
        return String(byteValue, radix: 16).uppercased().padded()
    }
    
    func stringValue() -> String {
        return String(byteValue)
    }
    
    func ld(value: UInt8){
        self.byteValue = value
    }
    
    func setBit(bit: Int) {
        byteValue = (byteValue | 1 << bit)
    }
    
    func clearBit(bit: Int) {
        byteValue = (byteValue & ~(1 << bit))
    }
    
    func readBit(bit: Int) -> Bool {
        return byteValue.isSet(bit: bit)
    }
    
    func inc() {
        byteValue = byteValue &+ 1
    }
    
    func dec() {
        byteValue = byteValue &- 1
    }
    
    func sub(diff: Int) {
    }
    
    func add(diff: Int) {
    }

    
}
