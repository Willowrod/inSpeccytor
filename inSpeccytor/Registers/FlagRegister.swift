//
//  FlagRegister.swift
//  inSpeccytor
//
//  Created by Mike Hall on 29/12/2020.
//

import Foundation
class FlagRegister: Register {
    
    private let FLAG_CARRY: UInt8 = 1
    private let FLAG_NEGATIVE: UInt8 = 2
    private let FLAG_PARITYOVERFLOW: UInt8 = 4
    private let FLAG_3: UInt8 = 8
    private let FLAG_HALFCARRY: UInt8 = 16
    private let FLAG_5: UInt8 = 32
    private let FLAG_35: UInt8 = 40
    private let FLAG_ZERO: UInt8 = 64
    private let FLAG_SIGN: UInt8 = 128
    
    func bits5And3(passedValue: UInt16){
        byteValue = byteValue & ~FLAG_3 | passedValue.highBit() & FLAG_3
        byteValue = byteValue & ~FLAG_5 | passedValue.highBit() & FLAG_5
    }
    
    func bits5And3(passedValue: UInt8){
        byteValue = byteValue & ~FLAG_35
    }
    
    func parity(passedValue: UInt8){
        print ("Checking parity on \(passedValue.bin()) (\(passedValue))")
        var count = 0
        for _ in 0...7 {
            if passedValue.isSet(bit: 0){
                count += 1
            }
        }
        byteValue = count % 2 == 0 ? byteValue | FLAG_PARITYOVERFLOW : byteValue & ~FLAG_PARITYOVERFLOW
    }
    
    func sign(passedValue: UInt8){
        byteValue = byteValue & ~FLAG_SIGN | passedValue & FLAG_SIGN
    }
    
    func zero(passedValue: UInt8){
        passedValue == 0 ? setBit(bit: Flag.ZERO) : clearBit(bit: Flag.ZERO)
    }
    
    func negative(){
        setBit(bit: Flag.SUBTRACT)
    }
    
    func positive(){
        clearBit(bit: Flag.SUBTRACT)
    }
    
    func carry(upperByte: UInt8){
        byteValue = byteValue & ~FLAG_CARRY | upperByte & FLAG_CARRY
    }
    
    func overFlow(passedValue: UInt8, oldValue: UInt8, newValue: UInt8){
        if oldValue & FLAG_SIGN == passedValue & FLAG_SIGN && newValue & FLAG_SIGN != oldValue & FLAG_SIGN {
            setBit(bit: Flag.OVERFLOW)
        } else {
            clearBit(bit: Flag.OVERFLOW)
        }
    }
    
    func halfCarry(passedValue: UInt8, oldValue: UInt8, carry: UInt8 = 0){
        if (oldValue.lowerNibble() &+ passedValue.lowerNibble() &+ carry) & 0x10 > 0 {
            setBit(bit: Flag.HALF_CARRY)
        } else {
            clearBit(bit: Flag.HALF_CARRY)
        }
    }
    
    func halfCarry(passedValue: UInt16, oldValue: UInt16){
        if (passedValue & 0x0fff) &+ (oldValue & 0x0fff) & 0x1000 > 0 {
            setBit(bit: Flag.HALF_CARRY)
        } else {
            clearBit(bit: Flag.HALF_CARRY)
        }
    }
    
}