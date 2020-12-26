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
        let oldValue = byteValue
        byteValue = byteValue &+ 1
        byteValue.set(bit: Flag.SIGN, value: byteValue.isSet(bit: 7))
        byteValue.set(bit: Flag.ZERO, value: byteValue == 0)
        byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 3) != byteValue.isSet(bit: 3))
        byteValue.clear(bit: Flag.SUBTRACT)
    }
    
    func dec() {
        let oldValue = byteValue
        byteValue = byteValue &- 1
        byteValue.set(bit: Flag.SIGN, value: byteValue.isSet(bit: 7))
        byteValue.set(bit: Flag.ZERO, value: byteValue == 0)
        byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 4) != byteValue.isSet(bit: 4))
        byteValue.set(bit: Flag.SUBTRACT)
        
    }
    
    func rlc(){
        let bit7 = byteValue.isSet(bit: 7)
        byteValue = byteValue << 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
        Z80.F.byteValue.set(bit: Flag.ZERO, value: byteValue == 0)
        byteValue.set(bit: 0, value: bit7)
        byteValue.set(bit: Flag.SIGN, value: byteValue.isSet(bit: 7))
    }
    
    func rrc(){
        let bit0 = byteValue.isSet(bit: 0)
        byteValue = byteValue >> 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        Z80.F.byteValue.set(bit: Flag.ZERO, value: byteValue == 0)
        byteValue.set(bit: 7, value: bit0)
        byteValue.set(bit: Flag.SIGN, value: byteValue.isSet(bit: 7))
    }
    
    func rl(){
        let bit7 = byteValue.isSet(bit: 7)
        byteValue = byteValue << 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        byteValue.set(bit: 0, value: Z80.F.byteValue.isSet(bit: Flag.CARRY))
        Z80.F.byteValue.set(bit: Flag.ZERO, value: byteValue == 0)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
        byteValue.set(bit: Flag.SIGN, value: byteValue.isSet(bit: 7))
    }
    
    func rr(){
        let bit0 = byteValue.isSet(bit: 0)
        byteValue = byteValue >> 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        byteValue.set(bit: 7, value: Z80.F.byteValue.isSet(bit: Flag.CARRY))
        Z80.F.byteValue.set(bit: Flag.ZERO, value: byteValue == 0)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        byteValue.set(bit: Flag.SIGN, value: byteValue.isSet(bit: 7))
    }

    
}
