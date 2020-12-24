//
//  Z80+Opcode.swift
//  inSpeccytor
//
//  Created by Mike Hall on 24/12/2020.
//

import Foundation
extension Z80 {
    
    
    func opCode(byte: UInt8){
        let byte1: UInt8 = ram[Int(PC &+ 1)]
        let byte2: UInt8 = ram[Int(PC &+ 2)]
        let word: UInt16 = (UInt16(byte2) * 256) + UInt16(byte1)
        switch byte {
        
                case 0xCB:
                  opCodeCB(byte: byte1)
                break
                case 0xDD:
                    opCodeDD(byte: byte1)
        
                break
                case 0xED:
                    opCodeED(byte: byte1)
        
                break
                case 0xFD:
                    opCodeFD(byte: byte1)
        break
        
        case 0: // NOP
            instructionComplete(states: 4)
//        break
//        case 0x01:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "LD BC,$$", m: "Load register pair BC with the value $$", l: 3, t: .DATA)
//        break
//        case 0x02:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (BC),A", m: "Load the contents of the memory address stored in BC with the value of register A", l: 1)
//        break
//        case 0x03:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC BC", m: " ", l: 1)
//        break
//        case 0x04:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC B", m: " ", l: 1)
//        break
//        case 0x05:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC B", m: " ", l: 1)
//        break
//        case 0x06:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,±", m: " ", l: 2)
//        break
//        case 0x07:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RLC A", m: " ", l: 1)
//        break
//        case 0x08:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "EX AF,AF'", m: " ", l: 1)
//        break
//        case 0x09:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD HL,BC", m: " ", l: 1)
//        break
//        case 0x0A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,(BC)", m: " ", l: 1)
//        break
//        case 0x0B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC BC", m: " ", l: 1)
//        break
//        case 0x0C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC C", m: " ", l: 1)
//        break
//        case 0x0D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC C", m: " ", l: 1)
//        break
//        case 0x0E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,±", m: " ", l: 2)
//        break
//        case 0x0F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RRC A", m: " ", l: 1)
//        break
//        case 0x10:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DJNZ##", m: " ", l: 2, t: .RELATIVE)
//        break
        case 0x11: //LD DE,nn
            de().ld(value: word)
        instructionComplete(states: 10, length: 3) //returnOpCode(v: code, c: "LD DE,$$", m: " ", l: 3, t: .DATA)
        break
//        case 0x12:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (DE),A", m: " ", l: 1)
//        break
//        case 0x13:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC DE", m: " ", l: 1)
//        break
//        case 0x14:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC D", m: " ", l: 1)
//        break
//        case 0x15:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC D", m: " ", l: 1)
//        break
//        case 0x16:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,±", m: " ", l: 2)
//        break
//        case 0x17:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RL A", m: " ", l: 1)
//
//    case 0x18:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JR ##", m: "Jump to routine at memory offset 2s $$ (##)", l: 2, e: true, t: .RELATIVE)
//
//        break
        case 0x19:
            hl().add(diff: de().value())
        instructionComplete(states: 15) //returnOpCode(v: code, c: "ADD HL,DE", m: " ", l: 1)
        break
//        case 0x1A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,(DE)", m: " ", l: 1)
//        break
//        case 0x1B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC DE", m: " ", l: 1)
//        break
//        case 0x1C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC E", m: " ", l: 1)
//        break
//        case 0x1D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC E", m: " ", l: 1)
//        break
//        case 0x1E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,±", m: " ", l: 2)
//        break
//        case 0x1F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RRA", m: " ", l: 1)
//        break
        case 0x20:
            if (f().isSet(bit: Flag.ZERO)){
                instructionComplete(states: 7, length: 2)
            } else {
                PC = PC &+ 2
                if byte1.isSet(bit: 7){
                    PC = PC &- UInt16(byte1.twosCompliment())
                } else {
                PC = PC &+ UInt16(byte1.twosCompliment())
                }
        instructionComplete(states: 12, length: 0)
            }
        break
        case 0x21:
            hl().ld(value: word)
            instructionComplete(states: 7, length: 3) //returnOpCode(v: code, c: "LD HL,$$", m: "Load the register pair HL with the value $$", l: 3, t: .DATA)
        break
        case 0x22:
            ram[Int(word)] = l()
            ram[Int(word + 1)] = h()
        instructionComplete(states: 16, length: 3) //returnOpCode(v: code, c: "LD ($$),HL", m: " ", l: 3, t: .DATA)
        break
        case 0x23:
            hl().inc()
        instructionComplete(states: 6) //returnOpCode(v: code, c: "INC HL", m: " ", l: 1)
        break
//        case 0x24:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC H", m: " ", l: 1)
//        break
//        case 0x25:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC H", m: " ", l: 1)
//        break
//        case 0x26:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,$$", m: " ", l: 2, t: .DATA)
//        break
//        case 0x27:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DAA", m: " ", l: 1)
//        break
        case 0x28:
            if (f().isSet(bit: Flag.ZERO)){
                PC = PC &+ 2
                if byte1.isSet(bit: 7){
                    PC = PC &- UInt16(byte1.twosCompliment())
                } else {
                PC = PC &+ UInt16(byte1.twosCompliment())
                }
        instructionComplete(states: 12, length: 0)
            } else {
                instructionComplete(states: 7, length: 2)
            }
        break
//        case 0x29:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD HL,HL", m: " ", l: 1)
//        break
//        case 0x2A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD HL,($$)", m: " ", l: 3, t: .DATA)
//        break
        case 0x2B:
            hl().dec()
        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC HL", m: " ", l: 1)
        break
//        case 0x2C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC L", m: " ", l: 1)
//        break
//        case 0x2D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC L", m: " ", l: 1)
//        break
//        case 0x2E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,±", m: " ", l: 2)
//        break
//        case 0x2F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP L", m: " ", l: 1)
//        break
        case 0x30:
            if (f().isSet(bit: Flag.CARRY)){
                instructionComplete(states: 7, length: 2)
            } else {
                PC = PC &+ 2
                if byte1.isSet(bit: 7){
                    PC = PC &- UInt16(byte1.twosCompliment())
                } else {
                PC = PC &+ UInt16(byte1.twosCompliment())
                }
        instructionComplete(states: 12, length: 0)
            }
        break
//        case 0x31:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD SP,$$", m: " ", l: 3, t: .DATA)
//        break
        case 0x32:
            ram[Int(word)] = a()
        instructionComplete(states: 13) //returnOpCode(v: code, c: "LD ($$),A", m: " ", l: 3, t: .DATA)
        break
//        case 0x33:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC SP", m: " ", l: 1)
//        break
        case 0x34:
            ram[Int(hl().value())] = ram[Int(hl().value())] &+ 1
        instructionComplete(states: 11) //returnOpCode(v: code, c: "INC (HL)", m: " ", l: 1)
        break
        case 0x35:
            ram[Int(hl().value())] = ram[Int(hl().value())] &- 1
        instructionComplete(states: 11) //returnOpCode(v: code, c: "INC (HL)", m: " ", l: 1)
        break
        case 0x36:
            ram[Int(hl().value())] = byte1
        instructionComplete(states: 10, length: 2) //returnOpCode(v: code, c: "LD (HL),$$", m: " ", l: 3, t: .DATA)
        break
//        case 0x37:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SCF", m: " ", l: 1)
//        break
//        case 0x38:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JR C, ##", m: "If the Carry flag is set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
//        break
//        case 0x39:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD HL,SP", m: " ", l: 1)
//        break
//        case 0x3A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,($$)", m: " ", l: 3, t: .DATA)
//        break
//        case 0x3B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC SP", m: " ", l: 1)
//        break
//        case 0x3C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC A", m: " ", l: 1)
//        break
//        case 0x3D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC A", m: " ", l: 1)
//        break
        case 0x3E: // LD A,$$
            aR().ld(value: byte1)
            instructionComplete(states: 7, length: 2)
        break
//        case 0x3F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CCF", m: " ", l: 1)
//        break
        case 0x40:
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,B", m: " ", l: 1)
        break
        case 0x41:
            bR().ld(value: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,C", m: " ", l: 1)
        break
        case 0x42:
            bR().ld(value: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,D", m: " ", l: 1)
        break
        case 0x43:
            bR().ld(value: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,E", m: " ", l: 1)
        break
        case 0x44:
            bR().ld(value: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,H", m: " ", l: 1)
        break
        case 0x45:
            bR().ld(value: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,L", m: " ", l: 1)
        break
        case 0x46:
            bR().ld(value: ram[Int(hl().value())])
        instructionComplete(states: 7) //returnOpCode(v: code, c: "LD B,(HL)", m: " ", l: 1)
        break
        case 0x47: //LD B,A
            bR().ld(value: a())
            instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,A", m: "Load register B with the value of register A", l: 1)
        break
        case 0x48:
            cR().ld(value: b())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,B", m: " ", l: 1)
        break
        case 0x49:
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,C", m: " ", l: 1)
        break
        case 0x4A:
            cR().ld(value: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,D", m: " ", l: 1)
        break
        case 0x4B:
            cR().ld(value: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,E", m: " ", l: 1)
        break
        case 0x4C:
            cR().ld(value: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,H", m: " ", l: 1)
        break
        case 0x4D:
            cR().ld(value: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,L", m: " ", l: 1)
        break
        case 0x4E:
            cR().ld(value: ram[Int(hl().value())])
        instructionComplete(states: 7) //returnOpCode(v: code, c: "LD C,(HL)", m: " ", l: 1)
        break
        case 0x4F:
            cR().ld(value: a())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,A", m: " ", l: 1)
        break
        case 0x50:
            dR().ld(value: b())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,B", m: " ", l: 1)
        break
        case 0x51:
            dR().ld(value: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,C", m: " ", l: 1)
        break
        case 0x52:
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,D", m: " ", l: 1)
        break
        case 0x53:
            dR().ld(value: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,E", m: " ", l: 1)
        break
        case 0x54:
            dR().ld(value: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,H", m: " ", l: 1)
        break
        case 0x55:
            dR().ld(value: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,L", m: " ", l: 1)
        break
        case 0x56:
            dR().ld(value: ram[Int(hl().value())])
        instructionComplete(states: 7) //returnOpCode(v: code, c: "LD D,(HL)", m: " ", l: 1)
        break
        case 0x57:
            dR().ld(value: a())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,A", m: " ", l: 1)
        break
        case 0x58:
            eR().ld(value: b())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,B", m: " ", l: 1)
        break
        case 0x59:
            eR().ld(value: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,C", m: " ", l: 1)
        break
        case 0x5A:
            eR().ld(value: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,D", m: " ", l: 1)
        break
        case 0x5B:
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,E", m: " ", l: 1)
        break
        case 0x5C:
            eR().ld(value: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,H", m: " ", l: 1)
        break
        case 0x5D:
            eR().ld(value: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,L", m: " ", l: 1)
        break
        case 0x5E:
            eR().ld(value: ram[Int(hl().value())])
        instructionComplete(states: 7) //returnOpCode(v: code, c: "LD E,(HL)", m: " ", l: 1)
        break
        case 0x5F:
            eR().ld(value: a())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,A", m: " ", l: 1)
        break
        case 0x60:
            hR().ld(value: b())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,B", m: " ", l: 1)
        break
        case 0x61:
            hR().ld(value: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,C", m: " ", l: 1)
        break
        case 0x62:
            hR().ld(value: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,D", m: " ", l: 1)
        break
        case 0x63:
            hR().ld(value: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,E", m: " ", l: 1)
        break
        case 0x64:
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,H", m: " ", l: 1)
        break
        case 0x65:
            hR().ld(value: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,L", m: " ", l: 1)
        break
        case 0x66:
            hR().ld(value: ram[Int(hl().value())])
        instructionComplete(states: 7) //returnOpCode(v: code, c: "LD H,(HL)", m: " ", l: 1)
        break
        case 0x67:
            hR().ld(value: a())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,A", m: " ", l: 1)
        break
        case 0x68:
            lR().ld(value: b())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,B", m: " ", l: 1)
        break
        case 0x69:
            lR().ld(value: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,C", m: " ", l: 1)
        break
        case 0x6A:
            lR().ld(value: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,D", m: " ", l: 1)
        break
        case 0x6B:
            lR().ld(value: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,E", m: " ", l: 1)
        break
        case 0x6C:
            lR().ld(value: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,H", m: " ", l: 1)
        break
        case 0x6D:
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,L", m: " ", l: 1)
        break
        case 0x6E:
            lR().ld(value: ram[Int(hl().value())])
        instructionComplete(states: 7) //returnOpCode(v: code, c: "LD L,(HL)", m: " ", l: 1)
        break
        case 0x6F:
            lR().ld(value: a())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,A", m: " ", l: 1)
        break
        case 0x70:
            ram[Int(hl().value())] = b()
        instructionComplete(states: 7)
        break
        case 0x71:
            ram[Int(hl().value())] = c()
        instructionComplete(states: 7)
        break
        case 0x72:
            ram[Int(hl().value())] = d()
        instructionComplete(states: 7)
        break
        case 0x73:
            ram[Int(hl().value())] = e()
        instructionComplete(states: 7)
        break
        case 0x74:
            ram[Int(hl().value())] = h()
        instructionComplete(states: 7)
        break
        case 0x75:
            ram[Int(hl().value())] = l()
        instructionComplete(states: 7)
        break
//        case 0x76:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "HALT", m: " ", l: 1)
//        break
        case 0x77:
            ram[Int(hl().value())] = a()
        instructionComplete(states: 7)
        break
        case 0x78:
            aR().ld(value: b())
            instructionComplete(states: 4)
        break
        case 0x79:
            aR().ld(value: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,C", m: " ", l: 1)
        break
        case 0x7A:
            aR().ld(value: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,D", m: " ", l: 1)
        break
        case 0x7B:
            aR().ld(value: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,E", m: " ", l: 1)
        break
        case 0x7C:
            aR().ld(value: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,H", m: " ", l: 1)
        break
        case 0x7D:
            aR().ld(value: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,L", m: " ", l: 1)
        break
        case 0x7E:
            aR().ld(value: ram[Int(hl().value())])
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,(HL)", m: " ", l: 1)
        break
        case 0x7F:
        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,A", m: " ", l: 1)
        break
//        case 0x80:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,B", m: " ", l: 1)
//        break
//        case 0x81:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,C", m: " ", l: 1)
//        break
//        case 0x82:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,D", m: " ", l: 1)
//        break
//        case 0x83:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,E", m: " ", l: 1)
//        break
//        case 0x84:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,H", m: " ", l: 1)
//        break
//        case 0x85:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,L", m: " ", l: 1)
//        break
//        case 0x86:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,(HL)", m: " ", l: 1)
//        break
//        case 0x87:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,A", m: " ", l: 1)
//        break
        case 0x88:
            aR().aDC(diff: b())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,B", m: " ", l: 1)
        break
        case 0x89:
            aR().aDC(diff: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,C", m: " ", l: 1)
        break
        case 0x8A:
            aR().aDC(diff: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,D", m: " ", l: 1)
        break
        case 0x8B:
            aR().aDC(diff: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,E", m: " ", l: 1)
        break
        case 0x8C:
            aR().aDC(diff: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,H", m: " ", l: 1)
        break
        case 0x8D:
            aR().aDC(diff: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,L", m: " ", l: 1)
        break
        case 0x8E:
            aR().aDC(diff: ram[Int(hl().value())])
        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,(HL)", m: " ", l: 1)
        break
        case 0x8F:
            aR().aDC(diff: a())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,A", m: " ", l: 1)
        break
//        case 0x90:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,B", m: " ", l: 1)
//        break
//        case 0x91:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,C", m: " ", l: 1)
//        break
//        case 0x92:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,D", m: " ", l: 1)
//        break
//        case 0x93:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,E", m: " ", l: 1)
//        break
//        case 0x94:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,H", m: " ", l: 1)
//        break
//        case 0x95:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,L", m: " ", l: 1)
//        break
//        case 0x96:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,(HL)", m: " ", l: 1)
//        break
//        case 0x97:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,A", m: " ", l: 1)
//        break
//        case 0x98:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,B", m: " ", l: 1)
//        break
//        case 0x99:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,C", m: " ", l: 1)
//        break
//        case 0x9A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,D", m: " ", l: 1)
//        break
//        case 0x9B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,E", m: " ", l: 1)
//        break
//        case 0x9C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,H", m: " ", l: 1)
//        break
//        case 0x9D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,L", m: " ", l: 1)
//        break
//        case 0x9E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,(HL)", m: " ", l: 1)
//        break
//        case 0x9F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,A", m: " ", l: 1)
//        break
//        case 0xA0:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND B", m: " ", l: 1)
//        break
//        case 0xA1:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND C", m: " ", l: 1)
//        break
//        case 0xA2:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND D", m: " ", l: 1)
//        break
//        case 0xA3:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND E", m: " ", l: 1)
//        break
//        case 0xA4:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND H", m: " ", l: 1)
//        break
//        case 0xA5:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND L", m: " ", l: 1)
//        break
//        case 0xA6:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND (HL)", m: " ", l: 1)
//        break
        case 0xA7:
            aR().aND()
        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND A", m: " ", l: 1)
        break
//        case 0xA8:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR B", m: " ", l: 1)
//        break
//        case 0xA9:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR C", m: " ", l: 1)
//        break
//        case 0xAA:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR D", m: " ", l: 1)
//        break
//        case 0xAB:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR E", m: " ", l: 1)
//        break
//        case 0xAC:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR H", m: " ", l: 1)
//        break
//        case 0xAD:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR L", m: " ", l: 1)
//        break
//        case 0xAE:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR (HL)", m: " ", l: 1)
//        break
        case 0xAF:
            aR().xOR()
        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR A", m: " ", l: 1)
        break
        case 0xB0:
            aR().oR(value: b())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR B", m: " ", l: 1)
        break
        case 0xB1:
            aR().oR(value: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR C", m: " ", l: 1)
        break
        case 0xB2:
            aR().oR(value: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR D", m: " ", l: 1)
        break
        case 0xB3:
            aR().oR(value: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR E", m: " ", l: 1)
        break
        case 0xB4:
            aR().oR(value: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR H", m: " ", l: 1)
        break
        case 0xB5:
            aR().oR(value: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR L", m: " ", l: 1)
        break
        case 0xB6:
            aR().oR(value: ram[Int(hl().value())])
        instructionComplete(states: 7)
        break
        case 0xB7:
            aR().oR()
        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR A", m: " ", l: 1)
        break
        case 0xB8:
            aR().compare(value: b())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP B", m: " ", l: 1)
        break
        case 0xB9:
            aR().compare(value: c())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP C", m: " ", l: 1)
        break
        case 0xBA:
            aR().compare(value: d())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP D", m: " ", l: 1)
        break
        case 0xBB:
            aR().compare(value: e())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP E", m: " ", l: 1)
        break
        case 0xBC:
            aR().compare(value: h())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP H", m: " ", l: 1)
        break
        case 0xBD:
            aR().compare(value: l())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP L", m: " ", l: 1)
        break
        case 0xBE:
            aR().compare(value: ram[Int(hl().value())])
        instructionComplete(states: 7) //returnOpCode(v: code, c: "CP (HL)", m: " ", l: 1)
        break
        case 0xBF:
            aR().compare(value: a())
        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP A", m: " ", l: 1)
        break
//        case 0xC0:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET NZ", m: " ", l: 1)
//        break
//        case 0xC1:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "POP BC", m: " ", l: 1)
//        break
//        case 0xC2:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP NZ,$$", m: " ", l: 3, t: .CODE)
//        break
        case 0xC3: //JP $$
            PC = word
            instructionComplete(states: 10, length: 0) //returnOpCode(v: code, c: "JP $$", m: "Jump to routine at memory location $$", l: 3, e: true, t: .CODE)
        break
//        case 0xC4:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL NZ,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xC5:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "PUSH BC", m: " ", l: 1)
//        break
//        case 0xC6:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD A,±", m: " ", l: 2)
//        break
//        case 0xC7:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST 0", m: " ", l: 1)
//        break
//        case 0xC8:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "RET Z", m: " ", l: 1)
//        break
//        case 0xC9:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET", m: " ", l: 1, e: true)
//        break
//        case 0xCA:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "JP Z, $$", m: "If the Zero flag is set in register F, jump to routine at memory location $$", l: 3, t: .CODE)
//
//
//        break
//        case 0xCC:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL Z,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xCD:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL $$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xCE:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,±", m: " ", l: 2)
//        break
//        case 0xCF:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST &08", m: " ", l: 1)
//        break
//        case 0xD0:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET NC", m: " ", l: 1)
//        break
//        case 0xD1:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "POP DE", m: " ", l: 1)
//        break
//        case 0xD2:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP NC,$$", m: " ", l: 3, t: .CODE)
//        break
        case 0xD3: // TODO OUT (±),A
        instructionComplete(states: 11, length: 2) //returnOpCode(v: code, c: "OUT (±),A", m: " ", l: 2)
        break
//        case 0xD4:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL NC,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xD5:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "PUSH DE", m: " ", l: 1)
//        break
//        case 0xD6:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SUB A,±", m: " ", l: 2)
//        break
//        case 0xD7:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST &10", m: " ", l: 1)
//        break
//        case 0xD8:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET C", m: " ", l: 1)
//        break
//        case 0xD9:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "EXX", m: " ", l: 1)
//        break
//        case 0xDA:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP C,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xDB:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "IN A,(±)", m: "Load register A with an input defined by the current value of A from port $$ (Generally keyboard input) ", l: 2, t: .VALUE)
//        break
//        case 0xDC:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL C,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xDE:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "SBC A,±", m: " ", l: 2)
//        break
//        case 0xDF:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST &18", m: " ", l: 1)
//        break
//        case 0xE0:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET PO", m: " ", l: 1)
//        break
//        case 0xE1:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "POP HL", m: " ", l: 1)
//        break
//        case 0xE2:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP PO,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xE3:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "EX (SP),HL", m: " ", l: 1)
//        break
//        case 0xE4:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL PO,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xE5:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "PUSH HL", m: " ", l: 1)
//        break
//            case 0xE6:
//                instructionComplete(states: 4) //returnOpCode(v: code, c: "AND ±", m: "Update A to only contain bytes set in both A and the value ±", l: 2)
//            break
//        case 0xE7:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST &20", m: " ", l: 1)
//        break
//        case 0xE8:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET PE", m: " ", l: 1)
//        break
//        case 0xE9:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP (HL)", m: " ", l: 1)
//        break
//        case 0xEA:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP PE,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xEB:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "EX DE,HL", m: " ", l: 1)
//        break
//        case 0xEC:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL PE,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xEE:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR ±", m: " ", l: 2)
//        break
//        case 0xEF:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST &28", m: " ", l: 1)
//        break
//        case 0xF0:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET P", m: " ", l: 1)
//        break
//        case 0xF1:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "POP AF", m: " ", l: 1)
//        break
//        case 0xF2:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP P,$$", m: " ", l: 3, t: .CODE)
        case 0xF3:
        interupt = false
        interupt2 = false
        instructionComplete(states: 4) //returnOpCode(v: code, c: "DI", m: " ", l: 1)
        break
//        break
//        case 0xF4:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL P,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xF5:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "PUSH AF", m: " ", l: 1)
//        break
//        case 0xF6:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR ±", m: " ", l: 2)
//        break
//        case 0xF7:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST &30", m: " ", l: 1)
//        break
//        case 0xF8:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET M", m: " ", l: 1)
//        break
//        case 0xF9:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD SP,HL", m: " ", l: 1)
//        break
//        case 0xFA:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP M,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xFB:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "EI", m: " ", l: 1)
//        break
//        case 0xFC:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CALL M,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xFE:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP ±", m: " ", l: 2)
//        break
//        case 0xFF:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST &38", m: " ", l: 1)
        default:
            print("Unknown code \(String(byte, radix: 16))")
            print("-")
        }
    }
    
}
