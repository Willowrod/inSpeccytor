//
//  Accumilator.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation

class Accumilator: Register {
    
    override func sub(diff: Int) {
        if (byteValue < diff){
            byteValue = 255
            return
        }
        byteValue -= 1
    }
    
    override func add(diff: Int) {
        let newVal = Int(byteValue) + diff
        if (newVal > 255){
            byteValue = UInt8(newVal - 256)
            Z80.F.setBit(bit: 0)
            return
        }
        Z80.F.clearBit(bit: 0)
        byteValue = UInt8(newVal)
    }
}
