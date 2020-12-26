//
//  Accumilator.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation

class Accumilator: Register {
    
    func sub(diff: UInt8) {
        byteValue = byteValue &- diff
    }
    
    func add(diff: UInt8) {
        byteValue = byteValue &+ diff
        Z80.F.clearBit(bit: 0)
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
        byteValue = byteValue ^ value
        Z80.F.byteValue.set(bit: Flag.ZERO, value: (byteValue == 0))
        Z80.F.byteValue.set(bit: Flag.SUBTRACT, value: (byteValue.isSet(bit: 7)))
        Z80.F.byteValue.clear(bit: Flag.CARRY)
    }
    
    func oR(value: UInt8){
        byteValue = byteValue | value
        Z80.F.byteValue.set(bit: Flag.ZERO, value: (byteValue == 0))
        Z80.F.byteValue.set(bit: Flag.SUBTRACT, value: (byteValue.isSet(bit: 7)))
        Z80.F.byteValue.clear(bit: Flag.CARRY)
    }
    
    func aND(value: UInt8){
        byteValue = byteValue &  value
        Z80.F.byteValue.set(bit: Flag.ZERO, value: (byteValue == 0))
        Z80.F.byteValue.set(bit: Flag.SUBTRACT, value: (byteValue.isSet(bit: 7)))
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
    
    func compare(value: UInt8){
        var carry = false
        var zero = false
        if byteValue == value{
            zero = true
        } else if byteValue < value {
            carry = true
        }
        Z80.F.byteValue.set(bit: Flag.ZERO, value: zero)
        Z80.F.byteValue.set(bit: Flag.CARRY, value: carry)
        
    }
    
    func lowerNibble() -> UInt8 {
        return byteValue & 15
    }
    
    func upperNibble() -> UInt8 {
        return (byteValue & 240) >> 4
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
    
    
    
    
    func daA(){
// First, work out if this is an addition or subtraction change
        let upper = upperNibble()
        let lower = lowerNibble()
//
//        if upper < 0x10 && lower < 0x10 {
//            return
//        }
        
        let subtract = Z80.F.byteValue.isSet(bit: Flag.SUBTRACT)
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
        
//        if (subtract){ // Is subtraction
//            // Did we carry?
//            if (carry){ // Yes, we carried
//
//            } else { // We did not carry
//
//            }
//        } else { // Is addition
//
//        }
    }
    
}
