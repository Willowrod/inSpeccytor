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
    
    func lowerNibble() -> UInt8 {
        return self & 15
    }
    
    func upperNibble() -> UInt8 {
        return (self & 240) >> 4
    }
    
    mutating func inc() {
        let oldValue = self
        self = self &+ 1
        self.s53()
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != self.isSet(bit: 7))
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 3) != self.isSet(bit: 3))
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
    }
    
    mutating func dec() {
        let oldValue = self
        self = self &- 1
        self.s53()
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != self.isSet(bit: 7))
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 4) != self.isSet(bit: 4))
        Z80.F.byteValue.set(bit: Flag.SUBTRACT)
        
    }
    
    mutating func rlc(){
        let bit7 = self.isSet(bit: 7)
        self = self << 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        self.set(bit: 0, value: bit7)
        self.set(bit: Flag.SIGN, value: self.isSet(bit: 7))
    }
    
    mutating func rrc(){
        let bit0 = self.isSet(bit: 0)
        self = self >> 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        self.set(bit: 7, value: bit0)
        self.set(bit: Flag.SIGN, value: self.isSet(bit: 7))
    }
    
    mutating func rl(){
        let bit7 = self.isSet(bit: 7)
        self = self << 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        self.set(bit: 0, value: Z80.F.byteValue.isSet(bit: Flag.CARRY))
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
        self.set(bit: Flag.SIGN, value: self.isSet(bit: 7))
    }
    
    mutating func rr(){
        let bit0 = self.isSet(bit: 0)
        self = self >> 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        self.set(bit: 7, value: Z80.F.byteValue.isSet(bit: Flag.CARRY))
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        self.set(bit: Flag.SIGN, value: self.isSet(bit: 7))
    }
    
    mutating func sla(){
        let bit7 = self.isSet(bit: 7)
        self = self << 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        self.clear(bit: 0)
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
        Z80.F.byteValue.set(bit: Flag.PARITY)
        self.set(bit: Flag.SIGN, value: self.isSet(bit: 7))
    }
    
    mutating func sra(){
        let bit0 = self.isSet(bit: 0)
        let bit7 = self.isSet(bit: 7)
        self = self >> 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        Z80.F.byteValue.set(bit: Flag.PARITY, value: self.isSet(bit: 0))
        self.set(bit: 7, value: bit7)
        Z80.F.byteValue.set(bit: Flag.SIGN, value: bit7)
    }
    
    mutating func srl(){
        let bit0 = self.isSet(bit: 0)
        self = self >> 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.ZERO, value: self == 0)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        Z80.F.byteValue.set(bit: Flag.PARITY, value: self.isSet(bit: 0))
        self.clear(bit: 7)
        Z80.F.byteValue.clear(bit: Flag.SIGN)
    }
    
    func testBit(bit: Int){
        Z80.F.byteValue.set(bit: Flag.ZERO, value: !self.isSet(bit: bit))
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
    }
    
    func s53() {
        Z80.F.byteValue.set(bit: Flag.SIGN, value: self.isSet(bit: Flag.SIGN))
        Z80.F.byteValue.set(bit: 5, value: self.isSet(bit: 5))
        Z80.F.byteValue.set(bit: 3, value: self.isSet(bit: 3))
    }
    
    func parity(){
        var count = 0
        for _ in 0...7 {
            if self.isSet(bit: 0){
                count += 1
            }
        }
        Z80.F.byteValue.set(bit: Flag.PARITY, value: count % 2 == 0)
    }
    
    func hex() -> String {
        return String(self, radix: 16).padded(size: 2)
    }
    
    func bin() -> String {
        return String(self, radix: 2).padded(size: 8)
    }
    
}
