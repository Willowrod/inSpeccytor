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
        let targetByte = byte1.isSet(bit: 7) ? reg.value() &- UInt16(byte1.twosCompliment()) : reg.value() &+ UInt16(byte1)
        let opCodeOffset = Int(byte2 / 8)
        switch opCodeOffset {
        case 0: //RLC
            ram[Int(targetByte)].rlc()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 1: //RRC
            ram[Int(targetByte)].rrc()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 2: //RL
            ram[Int(targetByte)].rl()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 3: //RR
            ram[Int(targetByte)].rr()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 4: //SLA
            ram[Int(targetByte)].sla()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 5: //SRA
            ram[Int(targetByte)].sra()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 6: //SLL // Undocumented
            ram[Int(targetByte)].sll()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
            instructionComplete(states: 23, length: 3)
        case 7: //SRL
            ram[Int(targetByte)].srl()
            if let register = register {
                register.ld(value: ram[Int(targetByte)])
            }
                instructionComplete(states: 23, length: 3)
        case 8...15: //BIT 0
            ram[Int(targetByte)].testBit(bit: opCodeOffset - 8, memPtr: targetByte)
                    instructionComplete(states: 20, length: 3)
        case 16...23: // CLEAR
            ram[Int(targetByte)].clear(bit: opCodeOffset - 16)
                if let register = register {
                    register.ld(value: ram[Int(targetByte)])
                }
                instructionComplete(states: 23, length: 3)
        case 24...31: //SET
            ram[Int(targetByte)].set(bit: opCodeOffset - 24)
                if let register = register {
                    register.ld(value: ram[Int(targetByte)])
                }
                instructionComplete(states: 23, length: 3)

        
        default:
            print("Potential unknown code CB\(String(byte2, radix: 16)) From \(PC.hex())")
            print("-")
        }
    }
    
}
