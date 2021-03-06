//
//  Register.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation

class Register {
    var byteValue: UInt8 = 0xFF
    
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
        byteValue.inc()
    }
    
    func dec() {
        byteValue.dec()
    }
    
    func rlc(){
        byteValue.rlc()
    }
    
    func rrc(){
        byteValue.rrc()
    }
    
    func rl(){
        byteValue.rl()
    }
    
    func rr(){
        byteValue.rr()
    }
    
    func sla(){
        byteValue.sla()
    }
    
    func sra(){
        byteValue.sra()
    }
    
    func sll(){
        byteValue.sll()
    }
    
    func srl(){
        byteValue.srl()
    }
    
    func testBit(bit: Int){
        byteValue.testBit(bit: bit)
    }
    
    func inCommand(byte: UInt8){
        byteValue = byte
        Z80.F.clearBit(bit: Flag.HALF_CARRY)
        Z80.F.clearBit(bit: Flag.SUBTRACT)
        Z80.F.clearBit(bit: Flag.SIGN)
        Z80.F.zero(passedValue: byteValue)
        Z80.F.clearBit(bit: Flag.PARITY)
    }
    
}
