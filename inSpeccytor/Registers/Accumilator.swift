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
        let byteValue16: UInt16 = UInt16(byteValue) &- UInt16(diff)
        byteValue = byteValue16.lowBit()
        
        Z80.F.zero(passedValue: byteValue)
        Z80.F.overFlow(passedValue: diff, oldValue: oldValue, newValue: byteValue)
        Z80.F.halfCarry(passedValue: diff, oldValue: oldValue)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.negative()
        Z80.F.carry(upperByte: byteValue16.highByte())
    }
    
    func add(diff: UInt8) {
        let oldValue = byteValue
        let byteValue16: UInt16 = UInt16(byteValue) &+ UInt16(diff)
        byteValue = byteValue16.lowBit()
        
        Z80.F.zero(passedValue: byteValue)
        Z80.F.overFlow(passedValue: diff, oldValue: oldValue, newValue: byteValue)
        Z80.F.halfCarry(passedValue: diff, oldValue: oldValue)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.positive()
        Z80.F.carry(upperByte: byteValue16.highByte())
    }
    
    func sBC(diff: UInt8) {
        let carry = Z80.F.byteValue & 1
        let oldValue = byteValue
        let byteValue16: UInt16 = UInt16(byteValue) &- UInt16(diff) &- UInt16(carry)
        byteValue = byteValue16.lowBit()
        
        Z80.F.sign(passedValue: byteValue)
        Z80.F.zero(passedValue: byteValue)
        Z80.F.overFlow(passedValue: diff, oldValue: oldValue, newValue: byteValue)
        Z80.F.halfCarry(passedValue: diff, oldValue: oldValue, carry: carry)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.negative()
        Z80.F.carrySB(passedValue: diff &+ carry, oldValue: oldValue)
    }
    
    func aDC(diff: UInt8) {
        let carry = Z80.F.byteValue & 1
        let oldValue = byteValue
        let byteValue16: UInt16 = UInt16(byteValue) &+ UInt16(diff) &+ UInt16(carry)
        byteValue = byteValue16.lowBit()
        
        Z80.F.zero(passedValue: byteValue)
        Z80.F.overFlow(passedValue: diff, oldValue: oldValue, newValue: byteValue)
        Z80.F.halfCarry(passedValue: diff, oldValue: oldValue, carry: carry)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.positive()
        Z80.F.carry(upperByte: byteValue16.highByte())
    }
    
    func xOR(value: UInt8){
        byteValue = byteValue ^ value
        Z80.F.zero(passedValue: byteValue)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.carry(upperByte: 0)
        Z80.F.parity(passedValue: byteValue)
    }
    
    func oR(value: UInt8){
        byteValue = byteValue | value
        Z80.F.zero(passedValue: byteValue)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.carry(upperByte: 0)
        Z80.F.parity(passedValue: byteValue)
    }
    
    func aND(value: UInt8){
        byteValue = byteValue & value
        Z80.F.zero(passedValue: byteValue)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.carry(upperByte: 0)
        Z80.F.parity(passedValue: byteValue)
    }
    
    func xOR(){
        byteValue = 0
        Z80.F.byteValue.set(bit: Flag.ZERO)
        Z80.F.byteValue.clear(bit: Flag.SIGN)
        Z80.F.byteValue.clear(bit: Flag.CARRY)
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
        Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.parity(passedValue: byteValue)
        
    }
    
    func oR(){
        Z80.F.zero(passedValue: byteValue)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.byteValue.clear(bit: Flag.CARRY)
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
        Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.parity(passedValue: byteValue)
    }
    
    func aND(){
        Z80.F.zero(passedValue: byteValue)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.byteValue.clear(bit: Flag.CARRY)
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.parity(passedValue: byteValue)
    }
    
    func compare(value: UInt8){
            let byteValue16: UInt16 = UInt16(byteValue) &- UInt16(value)
            Z80.F.zero(passedValue: byteValue16.lowBit())
            Z80.F.overFlow(passedValue: value, oldValue: byteValue, newValue: byteValue16.lowBit())
            Z80.F.halfCarry(passedValue: byteValue16.lowBit(), oldValue: byteValue)
            Z80.F.sign(passedValue: byteValue16.lowBit())
            Z80.F.bits5And3(calculatedValue: byteValue16.lowBit())
            Z80.F.negative()
            Z80.F.carry(upperByte: byteValue16.highByte())
    }
    
    func rlcA(){
        let bit7 = byteValue.isSet(bit: 7)
        byteValue = byteValue << 1
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
        byteValue.set(bit: 0, value: bit7)
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
        Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
        Z80.F.bits5And3(calculatedValue: byteValue)
    }
    
    func rrcA(){
        let bit0 = byteValue.isSet(bit: 0)
        byteValue = byteValue >> 1
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        byteValue.set(bit: 7, value: bit0)
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
        Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
        Z80.F.bits5And3(calculatedValue: byteValue)
    }
    
    func rlA(){
        let bit7 = byteValue.isSet(bit: 7)
        byteValue = byteValue << 1
        byteValue.set(bit: 0, value: Z80.F.byteValue.isSet(bit: Flag.CARRY))
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit7)
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
        Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
        Z80.F.bits5And3(calculatedValue: byteValue)
    }
    
    func rrA(){
        let bit0 = byteValue.isSet(bit: 0)
        byteValue = byteValue >> 1
        byteValue.set(bit: 7, value: Z80.F.byteValue.isSet(bit: Flag.CARRY))
        Z80.F.byteValue.set(bit: Flag.CARRY, value: bit0)
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
        Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
        Z80.F.bits5And3(calculatedValue: byteValue)
    }
    
    func negate(){
        let oldValue = byteValue
        byteValue = ~byteValue &+ 1
        Z80.F.zero(passedValue: byteValue)
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7))
        Z80.F.halfCarry(passedValue: byteValue, oldValue: oldValue)
        Z80.F.sign(passedValue: byteValue)
        Z80.F.bits5And3(calculatedValue: byteValue)
        Z80.F.negative()
        Z80.F.byteValue.set(bit: Flag.CARRY, value: oldValue != 0)
    }
    
    
    func daA(){ // TODO: Flags!!!!
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
    
    func cpl(){
     byteValue = ~byteValue
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY)
        Z80.F.byteValue.set(bit: Flag.SUBTRACT)
    }
    
}
