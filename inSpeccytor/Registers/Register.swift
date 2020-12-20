//
//  Register.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation

class Register {
    var byteValue: UInt8 = 0
    
    
    
    func value() -> Int {
        return Int(byteValue)
    }
    
    func hexValue() -> String {
        return String(byteValue, radix: 16).uppercased().padded()
    }
    
    func stringValue() -> String {
        return String(byteValue)
    }
    
    func ld(value: Int){
        if (value >= 0 && value < 256){
        self.byteValue = UInt8(value)
        }
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
        if (byteValue == 255){
            byteValue = 0
            return
        }
        byteValue += 1
    }
    
    func dec() {
        if (byteValue == 0){
            byteValue = 255
            return
        }
        byteValue -= 1
    }
    
    func sub(diff: Int) {
    }
    
    func add(diff: Int) {
    }
    
}
