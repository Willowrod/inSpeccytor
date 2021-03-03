//
//  Z80Assembler+Adds.swift
//  inSpeccytor
//
//  Created by Mike Hall on 08/02/2021.
//

import Foundation
extension Z80Assembler {
    func adc(secondPart: String, opCode: String) -> String {
        switch secondPart {
        case "A,(HL)":
        return "8E"
        case "HL,BC":
        return "ED 4A"
        case "HL,DE":
        return "ED 5A"
        case "HL,HL":
        return "ED 6A"
        case "HL,SP":
        return "ED 7A"
        default:
            break
        }
        let split = secondPart.split(separator: ",")
        if split.count == 2 && split[0] == "A"{
            if let offset = String(split[1]).regOffset() {
                return (0x88 &+ offset).hex()
            }
            
            if let offset = String(split[1]).validUInt8() {
                return "CE \(offset.hex())"
            }
            if let displacement = String(split[1]).displacement(){
                if split[1].contains("IX+") {
                    return "DD 8E \(displacement)"
                }
                if split[1].contains("IY+") {
                    return "FD 8E \(displacement)"
                }
            }
            
        }
        print("ADC did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func add(secondPart: String, opCode: String) -> String {
        switch secondPart {
        case "A,(HL)":
        return "86"
        case "HL,BC":
        return "09"
        case "HL,DE":
        return "19"
        case "HL,HL":
        return "29"
        case "HL,SP":
        return "39"
        case "IX,BC":
        return "DD 09"
        case "IX,DE":
        return "DD 19"
        case "IX,IX":
        return "DD 29"
        case "IX,SP":
        return "DD 39"
        case "IY,BC":
        return "FD 09"
        case "IY,DE":
        return "FD 19"
        case "IY,IX":
        return "FD 29"
        case "IY,SP":
        return "FD 39"
        default:
            break
        }
        let split = secondPart.split(separator: ",")
        if split.count == 2 && split[0] == "A"{
            if let offset = String(split[1]).regOffset() {
                return (0x80 &+ offset).hex()
            }
            
            if let offset = String(split[1]).validUInt8() {
                return "C6 \(offset.hex())"
            }
            if let displacement = String(split[1]).displacement(){
                if split[1].contains("IX+") {
                    return "DD 86 \(displacement)"
                }
                if split[1].contains("IY+") {
                    return "FD 86 \(displacement)"
                }
            }
            
        }
        print("ADD did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func inc(secondPart: String, opCode: String) -> String {
        switch secondPart {
        case "A":
        return "3C"
        case "B":
        return "04"
        case "BC":
        return "03"
        case "C":
        return "0C"
        case "D":
        return "14"
        case "DE":
        return "13"
        case "E":
        return "1C"
        case "H":
        return "24"
        case "HL":
        return "23"
        case "L":
        return "2C"
        case "IX":
        return "DD 23"
        case "IY":
        return "FD 23"
        case "SP":
        return "33"
        case "(HL)":
        return "34"

        default:
            break
        }
            if let displacement = secondPart.displacement(){
                if secondPart.contains("IX+") {
                    return "DD 34 \(displacement)"
                }
                if secondPart.contains("IY+") {
                    return "FD 34 \(displacement)"
                }
            }
            
        print("INC did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
}
