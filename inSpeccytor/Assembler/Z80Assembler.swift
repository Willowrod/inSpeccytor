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
            
            
            
        default:
            print ("Opcode \(firstPart) unknown")
            return "XX"
        }
    }
    
    func ld(secondPart: String, opCode: String) -> String{
        var returnCode:UInt8 = 0x00
        let splitParts = secondPart.split(separator: ",")
        if  splitParts.count < 2 {
            print("Failed to parse LD for opcode \(opCode)")
            return "??"
        }
        // Pick off the low hanging fruit........ Let's put aside with what we don't know - IX and IY+n
        if splitParts[0].contains("+"){
            //           var split0 = splitParts[0].split(separator: "+")
        }
        
        if splitParts[1].contains("+"){
            //           var split1 = splitParts[1].split(separator: "+")
        }
        // OK let's sort the direct memory loads....
        if splitParts[0].count > 4 {
            var returner = ""
            let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            if let word = UInt16(address){
                returner = "\(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            switch splitParts[1] {
            case "A":
                return "32 \(returner)"
            case "BC":
                return "ED 43 \(returner)"
            case "DE":
                return "ED 53 \(returner)"
            case "HL":
                return "22 \(returner)"
            case "IX":
                return "DD 22 \(returner)"
            case "IY":
                return "FD 22 \(returner)"
            case "SP":
                return "ED 73 \(returner)"
            default:
                print("Direct memory load failed for opcode \(opCode)")
                return "??"
            }
        }
        
        switch splitParts[0] {
        case "(BC)":
            if splitParts[1] == "A" {
                return "02"
            }
        case "(DE)":
            if splitParts[1] == "A" {
                return "12"
            }
        case "(HL)":
            if let offset = String(splitParts[1]).regOffset() {
                return (0x70 &+ offset).hex()
            }
            
            if let offset = String(splitParts[1]).validUInt8() {
                return "36 \(offset.hex())"
            }
            
        case "A":
            if let offset = String(splitParts[1]).regOffset() {
                return (0x78 &+ offset).hex()
            }
            
            if let offset = String(splitParts[1]).validUInt8() {
                return "3E \(offset.hex())"
            }
            
            switch splitParts[1] {
            case "(BC)":
                return "0A"
            case "(DE)":
                return "1A"
            case "(HL)":
                return "7E"
            case "(IX)":
                return "DD 7E xx"
            case "(IY)":
                return "FD 7E xx"
            case "I":
                return "ED 57"
            case "R":
                return "ED 5F"
                
            default:
                if splitParts[1].contains("(") {
                    let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                    if let word = UInt16(address){
                        return "3A \(word.lowByte().hex()) \(word.highByte().hex())"
                    }
                }
            }
            
        case "B":
            if let offset = String(splitParts[1]).regOffset() {
                return (0x40 &+ offset).hex()
            }
            
            if let offset = String(splitParts[1]).validUInt8() {
                return "06 \(offset.hex())"
            }
            
            switch splitParts[1] {
            case "(HL)":
                return "46"
            case "(IX)":
                return "DD 46 xx"
            case "(IY)":
                return "FD 46 xx"
            default:
                break
            }
        case "C":
            if let offset = String(splitParts[1]).regOffset() {
                return (0x48 &+ offset).hex()
            }
            
            if let offset = String(splitParts[1]).validUInt8() {
                return "0E \(offset.hex())"
            }
            
            switch splitParts[1] {
            case "(HL)":
                return "4E"
            case "(IX)":
                return "DD 4E xx"
            case "(IY)":
                return "FD 4E xx"
            default:
                break
            }
            
        case "D":
            if let offset = String(splitParts[1]).regOffset() {
                return (0x50 &+ offset).hex()
            }
            
            if let offset = String(splitParts[1]).validUInt8() {
                return "16 \(offset.hex())"
            }
            
            switch splitParts[1] {
            case "(HL)":
                return "56"
            case "(IX)":
                return "DD 56 xx"
            case "(IY)":
                return "FD 56 xx"
            default:
                break
            }
            
        case "E":
            if let offset = String(splitParts[1]).regOffset() {
                return (0x58 &+ offset).hex()
            }
            
            if let offset = String(splitParts[1]).validUInt8() {
                return "1E \(offset.hex())"
            }
            
            switch splitParts[1] {
            case "(HL)":
                return "5E"
            case "(IX)":
                return "DD 5E xx"
            case "(IY)":
                return "FD 5E xx"
            default:
                break
            }
            
        case "H":
            if let offset = String(splitParts[1]).regOffset() {
                return (0x60 &+ offset).hex()
            }
            
            if let offset = String(splitParts[1]).validUInt8() {
                return "26 \(offset.hex())"
            }
            
            switch splitParts[1] {
            case "(HL)":
                return "66"
            case "(IX)":
                return "DD 66 xx"
            case "(IY)":
                return "FD 66 xx"
            default:
                break
            }
            
        case "L":
            if let offset = String(splitParts[1]).regOffset() {
                return (0x68 &+ offset).hex()
            }
            
            if let offset = String(splitParts[1]).validUInt8() {
                return "2E \(offset.hex())"
            }
            
            switch splitParts[1] {
            case "(HL)":
                return "6E"
            case "(IX)":
                return "DD 6E xx"
            case "(IY)":
                return "FD 6E xx"
            default:
                break
            }
            
        case "I":
            if splitParts[1] == "A" {
                return "ED 47"
            }
            
        case "R":
            if splitParts[1] == "A" {
                return "ED 4F"
            }
            
            
        case "BC":
            
            if let word = String(splitParts[1]).validUInt16() {
                return "01 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            if splitParts[1].contains("(") {
                let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = UInt16(address){
                    return "ED 4B \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
        
        case "DE":
            
            if let word = String(splitParts[1]).validUInt16() {
                return "11 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            if splitParts[1].contains("(") {
                let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = UInt16(address){
                    return "ED 5B \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
        
        case "HL":
            
            if let word = String(splitParts[1]).validUInt16() {
                return "21 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            if splitParts[1].contains("(") {
                let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = UInt16(address){
                    return "2A \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
        
        case "IX":
            
            if let word = String(splitParts[1]).validUInt16() {
                return "DD 21 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            if splitParts[1].contains("(") {
                let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = UInt16(address){
                    return "DD 2A \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
        
        case "IY":
            
            if let word = String(splitParts[1]).validUInt16() {
                return "FD 21 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            if splitParts[1].contains("(") {
                let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = UInt16(address){
                    return "FD 2A \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
        
        case "SP":
            
            switch splitParts[1] {
            case "HL":
                return "F9"
            case "IX":
                return "DD F9"
            case "IY":
                return "FD F9"
            default:
                
                if let word = String(splitParts[1]).validUInt16() {
                    return "31 \(word.lowByte().hex()) \(word.highByte().hex())"
                }
                
                if splitParts[1].contains("(") {
                    let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                    if let word = UInt16(address){
                        return "ED 7B \(word.lowByte().hex()) \(word.highByte().hex())"
                    }
                }
            }
            
            
            
            
            
        default:
            if splitParts[1].contains("(") {
                let address = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = UInt16(address){
                    return "3A \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }

            print("Load failed for opcode \(opCode)")
            return "??"
        }
        
    
    
    
    print("LD did not conform to any known pattern for opcode \(opCode)")
    return "??"
}

}
