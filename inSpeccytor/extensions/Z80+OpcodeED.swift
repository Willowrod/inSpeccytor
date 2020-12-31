//
//  Z80+OpcodeED.swift
//  inSpeccytor
//
//  Created by Mike Hall on 24/12/2020.
//

import Foundation
extension Z80 {
    
    func opCodeED(byte: UInt8){
        PC = PC &+ 1
        let byte1: UInt8 = ram[Int(PC &+ 1)]
        let byte2: UInt8 = ram[Int(PC &+ 2)]
        let word: UInt16 = (UInt16(byte2) * 256) + UInt16(byte1)
        switch byte {

        case 0x40: //TODO: IN B,(C)
        instructionComplete(states: 4)
        break
        case 0x41: // TODO:OUT (C),B
        instructionComplete(states: 4)
        break
        case 0x42: // SBC HL,BC
            hl().sbc(diff: bc().value())
        instructionComplete(states: 15)
        break
        case 0x43: // LD ($$),BC
            ldRam(location: word, value: bc().value())
        instructionComplete(states: 20, length: 3)
        break
        case 0x44: // NEG
            aR().negate()
        instructionComplete(states: 8)
        break
        case 0x45: // RETN
            ret()
        instructionComplete(states: 14)
        break
        case 0x46: // IM0
            interuptMode = 0
        instructionComplete(states: 8)
        break
        case 0x47: //LD I,A
            I.ld(value: a())
            instructionComplete(states: 9)
        break
        case 0x48: // TODO: IN C, (C)
        instructionComplete(states: 12)
        break
        case 0x49: // TODO: OUT (C), C
        instructionComplete(states: 12)
        break
        case 0x4A: // ADC HL,BC
            hl().adc(diff: bc().value())
        instructionComplete(states: 15)
        break
        case 0x4B: // LD BC,($$)
            bc().ld(value: fetchRamWord(location: word))
        instructionComplete(states: 20, length: 3)
        break
        case 0x4D:
            ret()
        instructionComplete(states: 14)
        break
        case 0x4F: // LD R,A
            R.ld(value: a())
        instructionComplete(states: 4)
        break
        case 0x50: // TODO: IN D, (C)
        instructionComplete(states: 12)
        break
        case 0x51: // TODO: OUT (C), D
        instructionComplete(states: 12)
        break
        case 0x52: // SBC HL,DE
            hl().sbc(diff: de().value())
            instructionComplete(states: 15)
        break
        case 0x53: // LD ($$),DE
            ldRam(location: word, value: de().value())
        instructionComplete(states: 20, length: 3)
        break
        case 0x56: // IM1
            interuptMode = 1
        instructionComplete(states: 8)
        break
        case 0x57: // LD A,I
            aR().ld(value: I.value())
        instructionComplete(states: 9)
        break
        case 0x58: // TODO: IN E, (C)
        instructionComplete(states: 12)
        break
        case 0x59: // TODO: OUT (C), E
        instructionComplete(states: 12)
        break
        case 0x5A: // ADC HL,DE
            hl().adc(diff: de().value())
        instructionComplete(states: 15)
        break
        case 0x5B:// LD DE,($$)
            de().ld(value: fetchRamWord(location: word))
        instructionComplete(states: 20, length: 3)
        break
        case 0x5E: // IM2
            interuptMode = 2
        instructionComplete(states: 8)
        break
        case 0x5F: // LD A,R
            aR().ld(value: R.value())
        instructionComplete(states: 9)
        break
        case 0x60: // TODO: IN H, (C)
        instructionComplete(states: 12)
        break
        case 0x61: // TODO: OUT (C), H
        instructionComplete(states: 12)
        break
        case 0x62: // SBC HL,HL
            hl().sbc(diff: hl().value())
            instructionComplete(states: 15)
        break
        case 0x63:// LD ($$),HL
            //hl().ld(value: fetchRamWord(location: word))
            ldRam(location: word, value: hl().value())
        instructionComplete(states: 20, length: 3)
        break
        case 0x67: //RRD TODO: Needs testing!
            let aLN = a().lowerNibble()
            let hlRef = fetchRam(location: hl().value())
            let hlLN = hlRef.lowerNibble()
            let hlHN = hlRef.upperNibble()
            
            let nHL = (aLN << 4) &+ hlHN
            let nA = (a() & 240) &+ hlLN
            
            aR().ld(value: nA)
            ldRam(location: hl().value(), value: nHL)
        instructionComplete(states: 18)
        break
        case 0x68: // TODO: IN L, (C)
        instructionComplete(states: 12)
        break
        case 0x69: // TODO: OUT (C), L
            instructionComplete(states: 12)
        break
        case 0x6A: // ADC HL,HL
            hl().adc(diff: hl().value())
            instructionComplete(states: 15)
        break
        case 0x6B:// LD HL,($$)
            hl().ld(value: fetchRamWord(location: word))
        instructionComplete(states: 20, length: 3)
        break
        case 0x6F://RLD TODO: Needs testing!
            let aLN = a().lowerNibble()
            let hlRef = fetchRam(location: hl().value())
            let hlLN = hlRef.lowerNibble()
            let hlHN = hlRef.upperNibble()
            
            let nHL = (hlLN << 4) &+ aLN
            let nA = (a() & 240) &+ hlHN
            
            aR().ld(value: nA)
            ldRam(location: hl().value(), value: nHL)
        instructionComplete(states: 18)
            break

        case 0x72: //SBC HL,SP
            hl().sbc(diff: SP)
        instructionComplete(states: 15)
        break
        case 0x73: //LD ($$),SP
            ldRam(location: word, value: SP)
        instructionComplete(states: 20, length: 3)
        break
        case 0x78: // TODO: IN A,(C)
            instructionComplete(states: 12)
        break
        case 0x79: // TODO OUT (C),A
        instructionComplete(states: 12)
        break
        case 0x7A: // ADC HL,SP
            hl().adc(diff: SP)
        instructionComplete(states: 15)
        break
        case 0x7B: // LD SP,($$)
            SP = fetchRamWord(location: word)
            instructionComplete(states: 20, length: 3)
        break
        case 0xA0: // LDI
            ldRam(location: de().value(), value: fetchRam(location: hl().value()))
            de().inc()
            hl().inc()
            bc().dec()
            Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
            Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
            Z80.F.byteValue.set(bit: Flag.PARITY, value: bc().value() != 1)
        instructionComplete(states: 16)
        break
        case 0xA1: // CPI
            aR().compare(value: fetchRam(location: hl().value()))
            let zero = Z80.F.byteValue.isSet(bit: Flag.ZERO)
            hl().inc()
            bc().dec()
            Z80.F.byteValue.set(bit: Flag.ZERO, value: zero)
        instructionComplete(states: 21)
        break
        case 0xA2: // TODO: INI
        instructionComplete(states: 16)
        break
        case 0xA3: // TODO: OUTI
            instructionComplete(states: 16)
        break
        case 0xA8:// LDD
            ldRam(location: de().value(), value: fetchRam(location: hl().value()))
            de().dec()
            hl().dec()
            bc().dec()
            Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
            Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
            Z80.F.byteValue.set(bit: Flag.PARITY, value: bc().value() != 1)
        instructionComplete(states: 16)
        break
        case 0xA9: // CPI
            aR().compare(value: fetchRam(location: hl().value()))
            let zero = Z80.F.byteValue.isSet(bit: Flag.ZERO)
            hl().dec()
            bc().dec()
            Z80.F.byteValue.set(bit: Flag.ZERO, value: zero)
        instructionComplete(states: 16)
        break

            
            case 0xAA: // TODO: IND
            instructionComplete(states: 16)
            break
            case 0xAB: // TODO: OUTD
                instructionComplete(states: 16)
            break

                
        case 0xB0: // LDIR
            ldRam(location: de().value(), value: fetchRam(location: hl().value()))
            de().inc()
            hl().inc()
            bc().dec()
            Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
            Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
            Z80.F.byteValue.set(bit: Flag.PARITY, value: bc().value() != 1)
            if (bc().value() != 0){
                PC = PC &- 1
            instructionComplete(states: 21, length: 0)
            } else {
        instructionComplete(states: 16)
            }
        break
        case 0xB1: // CPI
            aR().compare(value: fetchRam(location: hl().value()))
            let zero = Z80.F.byteValue.isSet(bit: Flag.ZERO)
            hl().inc()
            bc().dec()
            Z80.F.byteValue.set(bit: Flag.ZERO, value: zero)
            if (zero || bc().value() == 0){
                instructionComplete(states: 16)
            } else {
                PC = PC &- 1
                instructionComplete(states: 21, length: 0)
            }
            
            
            
        break
        case 0xB2: // TODO: INIR
        instructionComplete(states: 16)
        break
        case 0xB3: // TODO: OUTIR
            instructionComplete(states: 16)
        break
        case 0xB8:// LDDR
            ldRam(location: de().value(), value: fetchRam(location: hl().value()))
            de().dec()
            hl().dec()
            bc().dec()
            Z80.F.byteValue.clear(bit: Flag.HALF_CARRY)
            Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
            Z80.F.byteValue.set(bit: Flag.PARITY, value: bc().value() != 1)
            if (bc().value() == 0){
                instructionComplete(states: 16)
            } else {
                PC = PC &- 1
                instructionComplete(states: 21, length: 0)
            }
        break
        case 0xB9: // CPIR
            aR().compare(value: fetchRam(location: hl().value()))
            let zero = Z80.F.byteValue.isSet(bit: Flag.ZERO)
            hl().dec()
            bc().dec()
            Z80.F.byteValue.set(bit: Flag.ZERO, value: zero)
            if (zero || bc().value() == 0){
                instructionComplete(states: 16)
            } else {
                PC = PC &- 1
                instructionComplete(states: 21, length: 0)
            }
        break

            
            case 0xBA: // TODO: IND
            instructionComplete(states: 16)
            break
            case 0xBB: // TODO: OUTD
                instructionComplete(states: 16)
            break


        default:
            print("Potential Unknown code ED\(String(byte, radix: 16))")
            print("-")
        }
    }
    
    
}