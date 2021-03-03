//
//  Z80Assembler.swift
//  inSpeccytor
//
//  Created by Mike Hall on 04/02/2021.
//

import Foundation

class Z80Assembler {
    
    var labelDictionary: Dictionary<String, Int> = Dictionary()
    
    func assemble(opCodeModel: OpCode) -> String {
        
        let original = opCodeModel.code.uppercased()
        let splitOpCode = original.split(separator: " ")
        let firstPart = splitOpCode[0]
        var secondPart = ""
        if (splitOpCode.count > 1){
            splitOpCode[1...].forEach{part in
                secondPart += part
            }
        }
        switch firstPart.uppercased() {
        case "NOP":
            return "00"
        case "DI":
            return "F3"
        case "LD", "LOAD":
            return ld(secondPart: secondPart, opCode: original)
        case "ADC":
            return adc(secondPart: secondPart, opCode: original)
        case "ADD":
            return add(secondPart: secondPart, opCode: original)
        case "INC":
            return inc(secondPart: secondPart, opCode: original)
        case "SBC":
            return sbc(secondPart: secondPart, opCode: original)
        case "SUB":
            return sub(secondPart: secondPart, opCode: original)
        case "DEC":
            return dec(secondPart: secondPart, opCode: original)
        case "CP":
            return cp(secondPart: secondPart, opCode: original)
        case "AND":
            return and(secondPart: secondPart, opCode: original)
        case "OR":
            return or(secondPart: secondPart, opCode: original)
        case "XOR":
            return xor(secondPart: secondPart, opCode: original)
        case "BIT":
            return bit(secondPart: secondPart, opCode: original)
        case "RES":
            return res(secondPart: secondPart, opCode: original)
        case "SET":
            return set(secondPart: secondPart, opCode: original)
        case "CALL":
            return call(secondPart: secondPart, opCode: original)
        case "JP":
            return jp(secondPart: secondPart, opCode: original)
        case "JR":
            return jr(secondPart: secondPart, opCode: original, line: opCodeModel.line)
        case "RET":
            return ret(secondPart: secondPart, opCode: original)
        case "RETI":
            return "ED 4D"
        case "RETN":
            return "ED 45"
        case "RST":
            return rst(secondPart: secondPart, opCode: original)
        case "DJNZ":
            return djnz(secondPart: secondPart, opCode: original, line: opCodeModel.line)
        case "EX":
            return ex(secondPart: secondPart, opCode: original)
        case "POP":
            return pop(secondPart: secondPart, opCode: original)
        case "PUSH":
            return push(secondPart: secondPart, opCode: original)
        case "RL":
            return rl(secondPart: secondPart, opCode: original)
        case "RLC":
            return rlc(secondPart: secondPart, opCode: original)
        case "RR":
            return rr(secondPart: secondPart, opCode: original)
        case "RRC":
            return rrc(secondPart: secondPart, opCode: original)
        case "SLA":
            return sla(secondPart: secondPart, opCode: original)
        case "SLL":
            return sll(secondPart: secondPart, opCode: original)
        case "SRA":
            return sra(secondPart: secondPart, opCode: original)
        case "SRL":
            return srl(secondPart: secondPart, opCode: original)
        case "IN":
            return portin(secondPart: secondPart, opCode: original)
        case "OUT":
            return portout(secondPart: secondPart, opCode: original)
        case "CCF":
            return "3F"
        case "CPD":
            return "ED A9"
        case "CPDR":
            return "ED B9"
        case "CPI":
            return "ED A1"
        case "CPIR":
            return "ED B1"
        case "CPL":
            return "2F"
        case "DAA":
            return "27"
        case "EI":
            return " FB"
        case "EXX":
            return "D9"
        case "HALT":
            return "76"
        case "IND":
            return "ED AA"
        case "INDR":
            return "ED BA"
        case "INI":
            return "ED A2"
        case "INIR":
            return "ED B2"
        case "LDD":
            return "ED A8"
        case "LDDR":
            return "ED B8"
        case "LDI":
            return "ED A0"
        case "LDIR":
            return "ED B0"
        case "NEG":
            return "ED 44"
        case "OTDR":
            return "ED BB"
        case "OTIR":
            return "ED B3"
        case "OUTD":
            return "ED AB"
        case "OUTI":
            return "ED A3"
        case "RLA":
            return "17"
        case "RLCA":
            return "07"
        case "RLD":
            return "ED 6F"
        case "RRA":
            return "1F"
        case "RRCA":
            return "0F"
        case "RRD":
            return "ED 67"
        case "SCF":
            return "37"
        case "IM0":
            return "ED 46"
        case "IM1":
            return "ED 56"
        case "IM2":
            return "ED 5E"
        case "CALC":
            return secondPart.replacingOccurrences(of: "$", with: "")
            
            
        default:
            return considerTheWhole(theWhole: original)
        }
    }
    
    func im(secondPart: String, opCode: String) -> String {
        
        switch secondPart {
        case "0":
            return "ED 46"
        case "1":
            return "ED 56"
        case "2":
            return "ED 5E"
        default:
            break
        }
        
        print("IM did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func considerTheWhole(theWhole: String) -> String{
        switch theWhole {
        case "END CALC":
            return "38"
        default:
            return "XX"
        }
    }
    
}
