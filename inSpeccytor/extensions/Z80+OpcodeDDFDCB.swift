//
//  Z80+OpcodeDDFDCB.swift
//  inSpeccytor
//
//  Created by Mike Hall on 28/12/2020.
//

import Foundation
extension Z80 {
    
    func opCodeDDFDCB(reg: RegisterPair){
        let byte1: UInt8 = ram[Int(PC &+ 1)]
        let byte2: UInt8 = ram[Int(PC &+ 2)]
        let register = getRegister(byte: byte2)
    //    let opCodeOffset = Int(byte2 / 8)
        let targetByte = byte1.isSet(bit: 7) ? reg.value() &- UInt16(byte1.twosCompliment()) : reg.value() &+ UInt16(byte1)
        switch byte2 {
        case 0x06: //RLC
            ram[Int(targetByte)].rlc()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 0x0E: //RRC
            ram[Int(targetByte)].rrc()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 0x16: //RL
            ram[Int(targetByte)].rl()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 0x1E: //RR
            ram[Int(targetByte)].rr()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 0x26: //SLA
            ram[Int(targetByte)].sla()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 0x2E: //SRA
            ram[Int(targetByte)].sra()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 0x3E: //SRL
            ram[Int(targetByte)].srl()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 0x46...0x7E: //BIT 0
            let opCodeOffset = Int(byte2 / 8)
                ram[Int(targetByte)].testBit(bit: opCodeOffset - 8)
//                if let register = register {
//                    register.ld(value: ram[Int(targetByte)])
//                }
                    instructionComplete(states: 20, length: 3)
        case 0x86...0xBE: //BIT 0
            let opCodeOffset = Int(byte2 / 8)
            ram[Int(targetByte)].clear(bit: opCodeOffset - 16)
                if let register = register {
                    register.ld(value: ram[Int(targetByte)])
                }
                instructionComplete(states: 23, length: 3)
        case 0xC6...0xFE: //BIT 0
            let opCodeOffset = Int(byte2 / 8)
            ram[Int(targetByte)].set(bit: opCodeOffset - 24)
                if let register = register {
                    register.ld(value: ram[Int(targetByte)])
                }
                instructionComplete(states: 23, length: 3)
        
        
        default:
            print("Potential unknown code CB\(String(byte2, radix: 16))")
            print("-")
        }
    }
    
}
