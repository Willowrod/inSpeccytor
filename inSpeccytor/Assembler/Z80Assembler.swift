//
//  Z80Assembler.swift
//  inSpeccytor
//
//  Created by Mike Hall on 04/02/2021.
//

import Foundation

class Z80Assembler {
    
    func assemble(opCode: String) -> String {
        let original = opCode.uppercased()
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
            return jr(secondPart: secondPart, opCode: original)
        case "RET":
            return ret(secondPart: secondPart, opCode: original)
        case "RETI":
            return "ED 4D"
        case "RETN":
            return "ED 45"
        case "RST":
            return rst(secondPart: secondPart, opCode: original)
        case "EX":
            return ex(secondPart: secondPart, opCode: original)
        case "POP":
            return pop(secondPart: secondPart, opCode: original)
        case "PUSH":
            return push(secondPart: secondPart, opCode: original)
        case "DJNZ":
            return djnz(secondPart: secondPart, opCode: original)
        case "RL":
            let retn = rl(secondPart: secondPart, opCode: original)
            print("Found \(opCode) - \(retn)")
            return rl(secondPart: secondPart, opCode: original)
            
            
            
        default:
            //print ("Opcode \(firstPart) unknown")
            return "XX"
        }
    }
    
    
    
    
}
