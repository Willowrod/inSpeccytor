//
//  Z80Assembler+Registry.swift
//  inSpeccytor
//
//  Created by Mike Hall on 09/02/2021.
//

import Foundation
extension Z80Assembler {
    
    func ex(secondPart: String, opCode: String) -> String {
        switch secondPart {
        case "(SP),HL":
            return "E3"
        case "(SP),IX":
            return "DD E3"
        case "(SP),IY":
            return "FD E3"
        case "DE,HL":
            return "EB"
        case "AF,AF'":
            return "08"
        default:
            break
        }
        print("EX did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func pop(secondPart: String, opCode: String) -> String {
        switch secondPart {
        case "AF":
            return "F1"
        case "BC":
            return "C1"
        case "DE":
            return "D1"
        case "HL":
            return "E1"
        case "IX":
            return "DD E1"
        case "IY":
            return "FD E1"
        default:
            break
        }
        print("POP did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func push(secondPart: String, opCode: String) -> String {
        switch secondPart {
        case "AF":
            return "F5"
        case "BC":
            return "C5"
        case "DE":
            return "D5"
        case "HL":
            return "E5"
        case "IX":
            return "DD E5"
        case "IY":
            return "FD E5"
        default:
            break
        }
        print("PUSH did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
}
