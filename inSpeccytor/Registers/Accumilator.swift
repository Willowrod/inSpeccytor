//
//  Accumilator.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation

class Accumilator: Register {
    
    func sub(diff: UInt8) {
        let oldValue = byteValue
        byteValue = byteValue &- diff
        byteValue.set(bit: Flag.SIGN, value: byteValue.isSet(bit: 7))
        byteValue.set(bit: Flag.ZERO, value: byteValue == 0)
        byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 4) != byteValue.isSet(bit: 4))
        byteValue.set(bit: Flag.SUBTRACT)
        
    }
    
    func add(diff: UInt8) {
        let oldValue = byteValue
        byteValue = byteValue &+ diff
        byteValue.set(bit: Flag.SIGN, value: byteValue.isSet(bit: 7))
        byteValue.set(bit: Flag.ZERO, value: byteValue == 0)
        byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 3) != byteValue.isSet(bit: 3))
        byteValue.clear(bit: Flag.SUBTRACT)
    }
    
    func sBC(diff: UInt8) {
        let current = byteValue
        byteValue = byteValue &- diff
        if (Z80.F.byteValue.isSet(bit: Flag.CARRY)){
            byteValue = byteValue &+ 1
        }
        if (byteValue > current){
            Z80.F.setBit(bit: Flag.CARRY)
        } else {
        Z80.F.clearBit(bit: Flag.CARRY)
        }
    }
    
    func aDC(diff: UInt8) {
        let current = byteValue
        byteValue = byteValue &+ diff
        if (Z80.F.byteValue.isSet(bit: Flag.CARRY)){
            byteValue = byteValue &+ 1
        }
        if (byteValue < current){
            Z80.F.setBit(bit: Flag.CARRY)
        } else {
        Z80.F.clearBit(bit: Flag.CARRY)
        }
    }
    
    func xOR(value: UInt8){
        let oldValue = byteValue
        byteValue = byteValue ^ value
        Z80.F.byteValue.set(bit: Flag.ZERO, value: (byteValue == 0))
        Z80.F.byteValue.set(bit: Flag.SIGN, value: (byteValue.isSet(bit: 7)))
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        Z80.F.byteValue.clear(bit: Flag.CARRY)
    }
    
    func oR(value: UInt8){
        let oldValue = byteValue
        byteValue = byteValue | value
        Z80.F.byteValue.set(bit: Flag.ZERO, value: (byteValue == 0))
        Z80.F.byteValue.set(bit: Flag.SIGN, value: (byteValue.isSet(bit: 7)))
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        Z80.F.byteValue.clear(bit: Flag.CARRY)
    }
    
    func aND(value: UInt8){
        let oldValue = byteValue
        byteValue = byteValue &  value
        Z80.F.byteValue.set(bit: Flag.ZERO, value: (byteValue == 0))
        Z80.F.byteValue.set(bit: Flag.SIGN, value: (byteValue.isSet(bit: 7)))
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        Z80.F.byteValue.clear(bit: Flag.CARRY)
    }
    
    func xOR(){
        byteValue = 0
        Z80.F.byteValue.clear(bit: Flag.CARRY)
    }
    
    func oR(){
        Z80.F.byteValue.clear(bit: Flag.CARRY)
    }
    
    func aND(){
        Z80.F.byteValue.clear(bit: Flag.CARRY)
    }
    
    func compare(value: UInt8){ // TODO: Signed compares?
        let oldValue = byteValue
        var carry = false
        var zero = false
        if byteValue == value{
            zero = true
        } else if byteValue < value {
            carry = true
        }
        Z80.F.byteValue.set(bit: Flag.ZERO, value: zero)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: carry)
        Z80.F.byteValue.set(bit: Flag.SIGN, value: carry)
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 3) != byteValue.isSet(bit: 3))
    }
    
    func rlcA(){
        let bit7 = byteValue.isSet(bit: 7)
        byteValue = byteValue << 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
        byteValue.set(bit: 0, value: bit7)
    }
    
    func rrcA(){
        let bit0 = byteValue.isSet(bit: 0)
        byteValue = byteValue >> 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        byteValue.set(bit: 7, value: bit0)
    }
    
    func rlA(){
        let bit7 = byteValue.isSet(bit: 7)
        byteValue = byteValue << 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        byteValue.set(bit: 0, value: Z80.F.byteValue.isSet(bit: Flag.CARRY))
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
    }
    
    func rrA(){
        let bit0 = byteValue.isSet(bit: 0)
        byteValue = byteValue >> 1
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        byteValue.set(bit: 7, value: Z80.F.byteValue.isSet(bit: Flag.CARRY))
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
    }
    
    func negate(){
        let oldValue = byteValue
        byteValue = ~byteValue &+ 1
        Z80.F.byteValue.set(bit: Flag.ZERO, value: (byteValue == 0))
        Z80.F.byteValue.set(bit: Flag.SIGN, value: (byteValue.isSet(bit: 7)))
        Z80.F.byteValue.set(bit: Flag.CARRY, value: oldValue != 0x00)
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != byteValue.isSet(bit: 7))
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 4) != byteValue.isSet(bit: 4))
        Z80.F.byteValue.set(bit: Flag.SUBTRACT)
    }
    
    
    func daA(){
        let upper = byteValue.upperNibble()
        let lower = byteValue.lowerNibble()
        let carry = Z80.F.byteValue.isSet(bit: Flag.CARRY)
        let halfCarry = Z80.F.byteValue.isSet(bit: Flag.HALF_CARRY)
        
        if (lower > 0x09 || halfCarry){
            byteValue = byteValue &+ 6
        }
        
        if (upper > 0x09 || carry){
            byteValue = byteValue &+ 0x60
            Z80.F.byteValue.set(bit: Flag.CARRY)
        } else {
        
            Z80.F.byteValue.clear(bit: Flag.CARRY)
        }
        
        Z80.F.byteValue.set(bit: Flag.ZERO, value: (byteValue == 0))
        Z80.F.byteValue.set(bit: Flag.SUBTRACT, value: (byteValue.isSet(bit: 7)))
        Z80.F.byteValue.set(bit: Flag.PARITY, value: !byteValue.isSet(bit: 0))
    }
    
}
