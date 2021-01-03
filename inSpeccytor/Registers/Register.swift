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
//        let oldValue = byteValue
//        byteValue = byteValue &+ 1
//        Z80.F.zero(passedValue: byteValue)
//        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue == 0x7f)
//        Z80.F.halfCarry(passedValue: 1, oldValue: oldValue)
//        Z80.F.positive()
//        Z80.F.sign(passedValue: byteValue)
//        Z80.F.bits5And3(calculatedValue: byteValue)
    }
    
    func dec() {
        byteValue.dec()
//        let oldValue = byteValue
//        byteValue = byteValue &- 1
//        Z80.F.zero(passedValue: byteValue)
//        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue == 0x80)
//        Z80.F.halfCarrySB(passedValue: 1, oldValue: oldValue)
//        Z80.F.negative()
//        Z80.F.sign(passedValue: byteValue)
//        Z80.F.bits5And3(calculatedValue: byteValue)
        
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
