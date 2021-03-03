//
//  Z80Assembly+Subtractions.swift
//  inSpeccytor
//
//  Created by Mike Hall on 08/02/2021.
//

import Foundation
extension Z80Assembler {
    func sbc(secondPart: String, opCode: String) -> String {
        switch secondPart {
        case "A,(HL)", "(HL)":
        return "9E"
        case "HL,BC":
        return "ED 42"
        case "HL,DE":
        return "ED 52"
        case "HL,HL":
        return "ED 62"
        case "HL,SP":
        return "ED 72"
        default:
            break
        }
        if let offset = secondPart.regOffset() {
            return (0x98 &+ offset).hex()
        }
        let split = secondPart.split(separator: ",")
        if split.count == 2 && split[0] == "A"{
            if let offset = String(split[1]).regOffset() {
                return (0x98 &+ offset).hex()
            }
            
            if let offset = String(split[1]).validUInt8() {
                return "DE \(offset.hex())"
            }
            if let displacement = String(split[1]).displacement(){
                if split[1].contains("IX+") {
                    return "DD 9E \(displacement)"
                }
                if split[1].contains("IY+") {
                    return "FD 9E \(displacement)"
                }
            }
            
        }
        print("SBC did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func sub(secondPart: String, opCode: String) -> String {
        let noASecondPart = secondPart.replacingOccurrences(of: "A,", with: "")
        if noASecondPart == "(HL)" {
            return "96"
        }
        
            if let offset = noASecondPart.regOffset() {
                return (0x90 &+ offset).hex()
            }

            
            if let offset = noASecondPart.validUInt8() {
                return "D6 \(offset.hex())"
            }
            if let displacement = noASecondPart.displacement(){
                if noASecondPart.contains("IX+") {
                    return "DD 96 \(displacement)"
                }
                if noASecondPart.contains("IY+") {
                    return "FD 96 \(displacement)"
                }
            }
            
        print("SUB did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func dec(secondPart: String, opCode: String) -> String {
        switch secondPart {
        case "A":
        return "3D"
        case "B":
        return "05"
        case "BC":
        return "0B"
        case "C":
        return "0D"
        case "D":
        return "15"
        case "DE":
        return "1B"
        case "E":
        return "1D"
        case "H":
        return "25"
        case "HL":
        return "2B"
        case "L":
        return "2D"
        case "IX":
        return "DD 2B"
        case "IY":
        return "FD 2B"
        case "SP":
        return "3B"
        case "(HL)":
        return "35"

        default:
            break
        }
            if let displacement = secondPart.displacement(){
                if secondPart.contains("IX+") {
                    return "DD 35 \(displacement)"
                }
                if secondPart.contains("IY+") {
                    return "FD 35 \(displacement)"
                }
            }
            
        print("DEC did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func cp(secondPart: String, opCode: String) -> String {

        
            if secondPart == "(HL)"{
                return "BE"
            }
            if let offset = secondPart.regOffset() {
                return (0xB8 &+ offset).hex()
            }

            if let offset = secondPart.validUInt8() {
                return "FE \(offset.hex())"
            }
            if let displacement = secondPart.displacement(){
                if secondPart.contains("IX+") {
                    return "DD BE \(displacement)"
                }
                if secondPart.contains("IY+") {
                    return "FD BE \(displacement)"
                }
            }
            
        print("CP did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
}
