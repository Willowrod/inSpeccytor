//
//  Z80+OpcodeDD.swift
//  inSpeccytor
//
//  Created by Mike Hall on 24/12/2020.
//

import Foundation
extension Z80 {
    
    
    func opCodeDD(byte: UInt8){
        PC = PC &+ 1
        let byte1: UInt8 = ram[Int(PC &+ 1)]
        let byte2: UInt8 = ram[Int(PC &+ 2)]
        let word: UInt16 = (UInt16(byte2) * 256) + UInt16(byte1)
        switch byte {
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
//        case 0x11:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD DE,$$", m: " ", l: 3, t: .DATA)
//        break
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
//        case 0x19:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD HL,DE", m: " ", l: 1)
//        break
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
//        case 0x20:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JR NZ, ##", m: "If the Zero flag is not set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
//        break
//        case 0x21:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "LD HL,$$", m: "Load the register pair HL with the value $$", l: 3, t: .DATA)
//        break
//        case 0x22:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD ($$),HL", m: " ", l: 3, t: .DATA)
//        break
//        case 0x23:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC HL", m: " ", l: 1)
//        break
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
//        case 0x28:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "JR Z, ##", m: "If the Zero flag is set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
//
//
//        break
//        case 0x29:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADD HL,HL", m: " ", l: 1)
//        break
//        case 0x2A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD HL,($$)", m: " ", l: 3, t: .DATA)
//        break
//        case 0x2B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC HL", m: " ", l: 1)
//        break
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
//        case 0x30:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JR NC, ##", m: "If the Carry flag is not set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
//        break
//        case 0x31:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD SP,$$", m: " ", l: 3, t: .DATA)
//        break
//        case 0x32:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD ($$),A", m: " ", l: 3, t: .DATA)
//        break
//        case 0x33:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC SP", m: " ", l: 1)
//        break
//        case 0x34:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "INC (HL)", m: " ", l: 1)
//        break
//        case 0x35:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DEC (HL)", m: " ", l: 1)
//        break
//        case 0x36:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (HL),$$", m: " ", l: 3, t: .DATA)
//        break
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
//        case 0x3E:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,$$", m: "Load register A with the value $$", l: 2, t: .DATA)
//
//
//        break
//        case 0x3F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CCF", m: " ", l: 1)
//        break
//        case 0x40:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,B", m: " ", l: 1)
//        break
//        case 0x41:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,C", m: " ", l: 1)
//        break
//        case 0x42:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,D", m: " ", l: 1)
//        break
//        case 0x43:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,E", m: " ", l: 1)
//        break
//        case 0x44:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,H", m: " ", l: 1)
//        break
//        case 0x45:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,L", m: " ", l: 1)
//        break
//        case 0x46:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,(HL)", m: " ", l: 1)
//        break
//        case 0x47:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "LD B,A", m: "Load register B with the value of register A", l: 1)
//
//
//        break
//        case 0x48:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,B", m: " ", l: 1)
//        break
//        case 0x49:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,C", m: " ", l: 1)
//        break
//        case 0x4A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,D", m: " ", l: 1)
//        break
//        case 0x4B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,E", m: " ", l: 1)
//        break
//        case 0x4C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,H", m: " ", l: 1)
//        break
//        case 0x4D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,L", m: " ", l: 1)
//        break
//        case 0x4E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,(HL)", m: " ", l: 1)
//        break
//        case 0x4F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD C,A", m: " ", l: 1)
//        break
//        case 0x50:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,B", m: " ", l: 1)
//        break
//        case 0x51:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,C", m: " ", l: 1)
//        break
//        case 0x52:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,D", m: " ", l: 1)
//        break
//        case 0x53:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,E", m: " ", l: 1)
//        break
//        case 0x54:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,H", m: " ", l: 1)
//        break
//        case 0x55:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,L", m: " ", l: 1)
//        break
//        case 0x56:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,(HL)", m: " ", l: 1)
//        break
//        case 0x57:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD D,A", m: " ", l: 1)
//        break
//        case 0x58:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,B", m: " ", l: 1)
//        break
//        case 0x59:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,C", m: " ", l: 1)
//        break
//        case 0x5A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,D", m: " ", l: 1)
//        break
//        case 0x5B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,E", m: " ", l: 1)
//        break
//        case 0x5C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,H", m: " ", l: 1)
//        break
//        case 0x5D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,L", m: " ", l: 1)
//        break
//        case 0x5E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,(HL)", m: " ", l: 1)
//        break
//        case 0x5F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD E,A", m: " ", l: 1)
//        break
//        case 0x60:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,B", m: " ", l: 1)
//        break
//        case 0x61:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,C", m: " ", l: 1)
//        break
//        case 0x62:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,D", m: " ", l: 1)
//        break
//        case 0x63:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,E", m: " ", l: 1)
//        break
//        case 0x64:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,H", m: " ", l: 1)
//        break
//        case 0x65:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,L", m: " ", l: 1)
//        break
//        case 0x66:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,(HL)", m: " ", l: 1)
//        break
//        case 0x67:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD H,A", m: " ", l: 1)
//        break
//        case 0x68:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,B", m: " ", l: 1)
//        break
//        case 0x69:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,C", m: " ", l: 1)
//        break
//        case 0x6A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,D", m: " ", l: 1)
//        break
//        case 0x6B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,E", m: " ", l: 1)
//        break
//        case 0x6C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,H", m: " ", l: 1)
//        break
//        case 0x6D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,L", m: " ", l: 1)
//        break
//        case 0x6E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,(HL)", m: " ", l: 1)
//        break
//        case 0x6F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD L,A", m: " ", l: 1)
//        break
//        case 0x70:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (HL),B", m: " ", l: 1)
//        break
//        case 0x71:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (HL),C", m: " ", l: 1)
//        break
//        case 0x72:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (HL),D", m: " ", l: 1)
//        break
//        case 0x73:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (HL),E", m: " ", l: 1)
//        break
//        case 0x74:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (HL),H", m: " ", l: 1)
//        break
//        case 0x75:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (HL),L", m: " ", l: 1)
//        break
//        case 0x76:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "HALT", m: " ", l: 1)
//        break
//        case 0x77:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD (HL),A", m: " ", l: 1)
//        break
//        case 0x78:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,B", m: "Load register A with the value of register B", l: 1)
//
//
//        break
//        case 0x79:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,C", m: " ", l: 1)
//        break
//        case 0x7A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,D", m: " ", l: 1)
//        break
//        case 0x7B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,E", m: " ", l: 1)
//        break
//        case 0x7C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,H", m: " ", l: 1)
//        break
//        case 0x7D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,L", m: " ", l: 1)
//        break
//        case 0x7E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,(HL)", m: " ", l: 1)
//        break
//        case 0x7F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "LD A,A", m: " ", l: 1)
//        break
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
//        case 0x88:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,B", m: " ", l: 1)
//        break
//        case 0x89:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,C", m: " ", l: 1)
//        break
//        case 0x8A:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,D", m: " ", l: 1)
//        break
//        case 0x8B:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,E", m: " ", l: 1)
//        break
//        case 0x8C:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,H", m: " ", l: 1)
//        break
//        case 0x8D:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,L", m: " ", l: 1)
//        break
//        case 0x8E:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,(HL)", m: " ", l: 1)
//        break
//        case 0x8F:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "ADC A,A", m: " ", l: 1)
//        break
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
//        case 0xA7:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "AND A", m: " ", l: 1)
//        break
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
//        case 0xAF:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "XOR A", m: " ", l: 1)
//        break
//        case 0xB0:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR B", m: " ", l: 1)
//        break
//        case 0xB1:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR C", m: " ", l: 1)
//        break
//        case 0xB2:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR D", m: " ", l: 1)
//        break
//        case 0xB3:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR E", m: " ", l: 1)
//        break
//        case 0xB4:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR H", m: " ", l: 1)
//        break
//        case 0xB5:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR L", m: " ", l: 1)
//        break
//        case 0xB6:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR (HL)", m: " ", l: 1)
//        break
//        case 0xB7:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OR A", m: " ", l: 1)
//        break
//        case 0xB8:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP B", m: " ", l: 1)
//        break
//        case 0xB9:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP C", m: " ", l: 1)
//        break
//        case 0xBA:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP D", m: " ", l: 1)
//        break
//        case 0xBB:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP E", m: " ", l: 1)
//        break
//        case 0xBC:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP H", m: " ", l: 1)
//        break
//        case 0xBD:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP L", m: " ", l: 1)
//        break
//        case 0xBE:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP (HL)", m: " ", l: 1)
//        break
//        case 0xBF:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP A", m: " ", l: 1)
//        break
//        case 0xC0:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RET NZ", m: " ", l: 1)
//        break
//        case 0xC1:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "POP BC", m: " ", l: 1)
//        break
//        case 0xC2:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "JP NZ,$$", m: " ", l: 3, t: .CODE)
//        break
//        case 0xC3:
//            instructionComplete(states: 4) //returnOpCode(v: code, c: "JP $$", m: "Jump to routine at memory location $$", l: 3, e: true, t: .CODE)
//
//
//        break
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
        //        case 0xCB:
        //            instructionComplete(states: 4) //returnOpCode(v: code, c: "PreCode", m: "", l: 0)
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
//        case 0xD3:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "OUT (±),A", m: " ", l: 2)
//        break
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
        //        case 0xDD:
        //            instructionComplete(states: 4) //returnOpCode(v: code, c: "PreCode", m: "", l: 0)
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
        //        case 0xE6:
        //            instructionComplete(states: 4) //returnOpCode(v: code, c: "AND ±", m: "Update A to only contain bytes set in both A and the value ±", l: 2)
        //

//        break
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
        //        case 0xED:
        //            instructionComplete(states: 4) //returnOpCode(v: code, c: "PreCode", m: "", l: 0)
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
//        break
//        case 0xF3:
//        I = false
//        I2 = false
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "DI", m: " ", l: 1)
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
        //        case 0xFD:
        //            instructionComplete(states: 4) //returnOpCode(v: code, c: "PreCode", m: "", l: 0)
//        break
//        case 0xFE:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "CP ±", m: " ", l: 2)
//        break
//        case 0xFF:
//        instructionComplete(states: 4) //returnOpCode(v: code, c: "RST &38", m: " ", l: 1)
        default:
            print("Potential Unknown code DD\(String(byte, radix: 16))")
            print("-")
        }
    }
    
}
