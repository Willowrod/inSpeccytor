//
//  Z80+OpcodeDDFDCB.swift
//  inSpeccytor
//
//  Created by Mike Hall on 28/12/2020.
//

import Foundation
extension Z80 {
    
    func opCodeDDFDCB(reg: RegisterPair){
        let byte1: UInt8 = fetchRam(location: PC &+ 1)
        let byte2: UInt8 = fetchRam(location: PC &+ 2)
        let register = getRegister(byte: byte2)
        let targetByte = byte1.isSet(bit: 7) ? reg.value() &- UInt16(byte1.twosCompliment()) : reg.value() &+ UInt16(byte1)
        var changeByte = fetchRam(location: targetByte)
        let opCodeOffset = Int(byte2 / 8)
        var writeBack = true
        switch opCodeOffset {
        case 0: //RLC
            changeByte.rlc()
        case 1: //RRC
            changeByte.rrc()
        case 2: //RL
            changeByte.rl()
        case 3: //RR
            changeByte.rr()
        case 4: //SLA
            changeByte.sla()
        case 5: //SRA
            changeByte.sra()
        case 6: //SLL // Undocumented
            changeByte.sll()
        case 7: //SRL
            changeByte.srl()
        case 8...15: //BIT 0
            changeByte.testBit(bit: opCodeOffset - 8, memPtr: targetByte)
            writeBack = false
            instructionComplete(states: 20, length: 3)
        case 16...23: // CLEAR
            changeByte.clear(bit: opCodeOffset - 16)
        case 24...31: //SET
            changeByte.set(bit: opCodeOffset - 24)
        default:
            print("Potential unknown code CB\(String(byte2, radix: 16)) From \(PC.hex())")
            print("-")
            writeBack = false
        }
        if writeBack {
            ldRam(location: targetByte, value: changeByte)
            if let register = register {
                register.ld(value: changeByte)
            }
            instructionComplete(states: 23, length: 3)
        }
    }
    
}
