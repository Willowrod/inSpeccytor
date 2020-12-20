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
    
    func ld(value: UInt){
        if (value <= 65535){
            high.byteValue = UInt8(value / 256)
            let lowValue = value - (UInt(high.byteValue) * 256)
            low.byteValue = UInt8(lowValue)
        } else {
            print ("RP Load error - Overloaded value (\(value))")
        }
    }
    
    func value() -> UInt{
        return (UInt(high.byteValue) * 256) + UInt(low.byteValue)
    }
    
    func swap(spare: RegisterPair){
        ld(value: spare.value())
    }
    
}
