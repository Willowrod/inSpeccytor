//
//  Z80+OpcodeCB.swift
//  inSpeccytor
//
//  Created by Mike Hall on 24/12/2020.
//

import Foundation
extension Z80 {
    
    func getRegister(byte: UInt8) -> Register? {
        switch byte % 8 {
        case 0:
            return bR()
        case 1:
            return cR()
        case 2:
            return dR()
        case 3:
            return eR()
        case 4:
            return hR()
        case 5:
            return lR()
        case 6:
            return nil
        default:
            return aR()
        }
    }
    
    func opCodeCB(byte: UInt8){
        PC = PC &+ 1
        let register = getRegister(byte: byte)
        let opCodeOffset = Int(byte / 8)
        switch opCodeOffset {
        case 0: //RLC
            if let register = register {
                register.rlc()
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].rlc()
                instructionComplete(states: 15)
            }
            break
        case 1: //RRC
            if let register = register {
                register.rrc()
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].rrc()
                instructionComplete(states: 15)
            }
            break
        case 2: //RL
            if let register = register {
                register.rl()
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].rl()
                instructionComplete(states: 15)
            }
            break
        case 3: //RR
            if let register = register {
                register.rr()
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].rr()
                instructionComplete(states: 15)
            }
            break
        case 4: //SLA
            if let register = register {
                register.sla()
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].sla()
                instructionComplete(states: 15)
            }
            break
        case 5: //SRA
            if let register = register {
                register.sra()
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].sra()
                instructionComplete(states: 15)
            }
            break
        case 7: //SRL
            if let register = register {
                register.srl()
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].srl()
                instructionComplete(states: 15)
            }
            break
        case 8...15: //BIT 0
            if let register = register {
                register.byteValue.testBit(bit: opCodeOffset - 8)
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].testBit(bit: opCodeOffset - 8)
                instructionComplete(states: 12)
            }
            break
        case 16...23: //BIT 0
            if let register = register {
                register.byteValue.clear(bit: opCodeOffset - 16)
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].clear(bit: opCodeOffset - 16)
                instructionComplete(states: 15)
            }
            break
        case 24...31: //BIT 0
            if let register = register {
                register.byteValue.set(bit: opCodeOffset - 24)
                instructionComplete(states: 8)
            } else {
                ram[Int(hl().value())].set(bit: opCodeOffset - 24)
                instructionComplete(states: 15)
            }
        
            
            break
        default:
            print("Potential unknown code CB\(String(byte, radix: 16))")
            print("-")
        }
    }
    
}