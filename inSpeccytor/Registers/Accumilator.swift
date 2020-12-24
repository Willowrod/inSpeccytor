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
}
