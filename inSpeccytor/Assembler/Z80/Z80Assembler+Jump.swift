//
//  Assembler+Jump.swift
//  inSpeccytor
//
//  Created by Mike Hall on 09/02/2021.
//

import Foundation
extension Z80Assembler {
    
    
    func call(secondPart: String, opCode: String) -> String {
        
        let split = secondPart.split(separator: ",")
        if split.count == 2{
            if let word = String(split[1]).validUInt16(labels: labelDictionary){
                let bytes = "\(word.lowByte().hex()) \(word.highByte().hex())"
                switch split[0] {
                case "C":
                    return "DC \(bytes)"
                case "M":
                    return "FC \(bytes)"
                case "NC":
                    return "D4 \(bytes)"
                case "NZ":
                    return "C4 \(bytes)"
                case "P":
                    return "F4 \(bytes)"
                case "PE":
                    return "EC \(bytes)"
                case "PO":
                    return "E4 \(bytes)"
                case "Z":
                    return "CC \(bytes)"
                default:
                    break
                }
            }
            
        }
        if let word = secondPart.validUInt16(labels: labelDictionary){
            let bytes = "\(word.lowByte().hex()) \(word.highByte().hex())"
            
            return "CD \(bytes)"
            
        }
        print("CALL did not conform to any known pattern for opcode \(opCode)")
        return "00 00 00"
    }
    
    func jp(secondPart: String, opCode: String) -> String {
        
        let split = secondPart.split(separator: ",")
        if split.count == 2{
            if let word = String(split[1]).validUInt16(labels: labelDictionary){
                let bytes = "\(word.lowByte().hex()) \(word.highByte().hex())"
                switch split[0] {
                case "C":
                    return "DA \(bytes)"
                case "M":
                    return "FA \(bytes)"
                case "NC":
                    return "D2 \(bytes)"
                case "NZ":
                    return "C2 \(bytes)"
                case "P":
                    return "F2 \(bytes)"
                case "PE":
                    return "EA \(bytes)"
                case "PO":
                    return "E2 \(bytes)"
                case "Z":
                    return "CA \(bytes)"
                default:
                    break
                }
            }
            
        }
        
        switch secondPart {
        case "(HL)":
            return "E9"
        case "(IX)":
            return "DD E9"
        case "(IY)":
            return "FD E9"
        default:
            break
        }
        
        
        if let word = secondPart.validUInt16(labels: labelDictionary){
            let bytes = "\(word.lowByte().hex()) \(word.highByte().hex())"
            
            return "C3 \(bytes)"
            
        }
        print("JP did not conform to any known pattern for opcode \(opCode)")
        return "00 00 00"
    }
    
    func jr(secondPart: String, opCode: String, line: Int) -> String {
        
        let split = secondPart.split(separator: ",")
        if split.count == 2{
            if let byte = String(split[1]).validUInt8(labels: labelDictionary, line: line+2)?.hex(){
                switch split[0] {
                case "C":
                    return "38 \(byte)"
                case "NC":
                    return "30 \(byte)"
                case "NZ":
                    return "20 \(byte)"
                case "Z":
                    return "28 \(byte)"
                default:
                    break
                }
            }
            
        }
        if let byte = secondPart.validUInt8(labels: labelDictionary, line: line+2)?.hex(){
            
            return "18 \(byte)"
            
        }
        print("JR did not conform to any known pattern for opcode \(opCode)")
        return "00 00"
    }
    
    func ret(secondPart: String, opCode: String) -> String {
        

                switch secondPart {
                case "":
                    return "C9"
                case "C":
                    return "D8"
                case "M":
                    return "F8"
                case "NC":
                    return "D0"
                case "NZ":
                    return "C0"
                case "P":
                    return "F0"
                case "PE":
                    return "E8"
                case "PO":
                    return "E0"
                case "Z":
                    return "C8"
                default:
                    break
                }
        print("RET did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func rst(secondPart: String, opCode: String) -> String {
        

                switch secondPart {
                case "0":
                    return "C7"
                case "8H", "&08":
                    return "CF"
                case "10H", "&10":
                    return "D7"
                case "18H", "&18":
                    return "DF"
                case "20H", "&20":
                    return "E7"
                case "28H", "&28":
                    return "EF"
                case "30H", "&30":
                    return "F7"
                case "38H", "&38":
                    return "FF"
                default:
                    break
                }
        print("RST did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func djnz(secondPart: String, opCode: String, line: Int) -> String {
        
        
        if let byte = secondPart.validUInt8(labels: labelDictionary, line: line+2)?.hex(){
            
            return "10 \(byte)"
            
        }
              
        print("DJNZ did not conform to any known pattern for opcode \(opCode)")
        return "00 00"
    }
    
}
