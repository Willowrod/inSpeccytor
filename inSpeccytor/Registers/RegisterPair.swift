//
//  RegisterPair.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation

class RegisterPair {
    var high = Register()
    var low = Register()
    
    func setAF(h: Accumilator) {
        high = h
    }
    
    func ld(pair: RegisterPair){
        high = pair.high
        low = pair.low
    }
    
    func ld(value: UInt16){
            high.byteValue = UInt8(value / 256)
            let lowValue = value - UInt16(high.byteValue) * 256
            low.byteValue = UInt8(lowValue)
    }
    
    func dec() {
        ld(value: value() &- 1)
    }
    
    func inc() {
        ld(value: value() &+ 1)
    }
    
    func sbc(diff: UInt16){
        let current:UInt16 = value()
        if (Z80.F.readBit(bit: Flag.CARRY)){
            ld(value: current &- 1 &- diff)
        } else {
            ld(value: current &- diff)
        }
        if (current < value()) {
            Z80.F.setBit(bit: Flag.CARRY)
        } else {
            Z80.F.clearBit(bit: Flag.CARRY)
        }
    }
    
    func adc(diff: UInt16){
        let current:UInt16 = value()
        if (Z80.F.readBit(bit: Flag.CARRY)){
            ld(value: current &+ 1 &+ diff)
        } else {
            ld(value: current &+ diff)
        }
        if (current > value()) {
            Z80.F.setBit(bit: Flag.CARRY)
        } else {
            Z80.F.clearBit(bit: Flag.CARRY)
        }
    }
    
    
    func sub(diff: UInt16){
            ld(value: value() &- diff)
    }
    
    func add(diff: UInt16){
            ld(value: value() &+ diff)
    }
    
    func ld(high: UInt8, low: UInt8){
        self.high.byteValue = high
        self.low.byteValue = low
    }
    
    func value() -> UInt16{
        return (UInt16(high.byteValue) * 256) + UInt16(low.byteValue)
    }
    
    func swap(spare: RegisterPair){
        ld(value: spare.value())
    }
    
    func setPairs(h: UInt8, l: UInt8){
        high.byteValue = h
        low.byteValue = l
    }
    
}
