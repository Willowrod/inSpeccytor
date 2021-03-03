//
//  Z80Assembler+Load.swift
//  inSpeccytor
//
//  Created by Mike Hall on 08/02/2021.
//

import Foundation

extension Z80Assembler {
    func ld(secondPart: String, opCode: String) -> String {
        let splitParts = secondPart.split(separator: ",")
        if  splitParts.count < 2 {
            print("Failed to parse LD for opcode \(opCode)")
            return "??"
        }
        
        if splitParts[0].contains("+"){
            var returnIXIY = ""
            let splitIXIY = splitParts[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").split(separator: "+")
            if splitIXIY.count == 2 {
                if (splitIXIY[0] == "IX"){
                    returnIXIY = "DD"
                } else if (splitIXIY[0] == "IY"){
                    returnIXIY = "FD"
                }
                if let displacement = String(splitIXIY[1]).validUInt8() {
                    if let offset = String(splitParts[1]).regOffset() {
                        return "\(returnIXIY) \((0x70 &+ offset).hex()) \(displacement.hex())"
                    } else if let offset = String(splitParts[1]).validUInt8() {
                        return "\(returnIXIY) 36 \(displacement.hex()) \(offset.hex())"
                    }
                    
                }
            }
            
            print("Failed to parse LD for opcode \(opCode)")
            return "??"
        }

        if splitParts[0].count > 4 {
            var returner = ""
            let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            if let word = address.validUInt16(labels: labelDictionary){
                returner = "\(word.lowByte().hex()) \(word.highByte().hex())"
            } else {
                returner = "00 00"
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
                return "00 00 00"
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
            case "I":
                return "ED 57"
            case "R":
                return "ED 5F"
                
            default:
                
                if let displacement = String(splitParts[1]).displacement(){
                    if splitParts[1].contains("IX+") {
                        return "DD 7E \(displacement)"
                    }
                    if splitParts[1].contains("IY+") {
                        return "FD 7E \(displacement)"
                    }
                }
                
                if splitParts[1].contains("(") {
                    let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                    if let word = address.validUInt16(labels: labelDictionary){
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
            default:
                if let displacement = String(splitParts[1]).displacement(){
                    if splitParts[1].contains("IX+") {
                        return "DD 46 \(displacement)"
                    }
                    if splitParts[1].contains("IY+") {
                        return "FD 46 \(displacement)"
                    }
                }
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
            default:
                if let displacement = String(splitParts[1]).displacement(){
                    if splitParts[1].contains("IX+") {
                        return "DD 4E \(displacement)"
                    }
                    if splitParts[1].contains("IY+") {
                        return "FD 4E \(displacement)"
                    }
                }
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
            default:
                if let displacement = String(splitParts[1]).displacement(){
                    if splitParts[1].contains("IX+") {
                        return "DD 56 \(displacement)"
                    }
                    if splitParts[1].contains("IY+") {
                        return "FD 56 \(displacement)"
                    }
                }
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
            default:
                if let displacement = String(splitParts[1]).displacement(){
                    if splitParts[1].contains("IX+") {
                        return "DD 5E \(displacement)"
                    }
                    if splitParts[1].contains("IY+") {
                        return "FD 5E \(displacement)"
                    }
                }
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
            default:
                if let displacement = String(splitParts[1]).displacement(){
                    if splitParts[1].contains("IX+") {
                        return "DD 66 \(displacement)"
                    }
                    if splitParts[1].contains("IY+") {
                        return "FD 66 \(displacement)"
                    }
                }
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
            default:
                if let displacement = String(splitParts[1]).displacement(){
                    if splitParts[1].contains("IX+") {
                        return "DD 6E \(displacement)"
                    }
                    if splitParts[1].contains("IY+") {
                        return "FD 6E \(displacement)"
                    }
                }
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
            
            if splitParts[1].contains("(") {
                let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = address.validUInt16(labels: labelDictionary){
                    return "ED 4B \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
            
            if let word = String(splitParts[1]).validUInt16(labels: labelDictionary) {
                return "01 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            print("Load failed for opcode \(opCode)")
            return "00 00 00 00"
            
        case "DE":
            
            
            if splitParts[1].contains("(") {
                let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = address.validUInt16(labels: labelDictionary){
                    return "ED 5B \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
            if let word = String(splitParts[1]).validUInt16(labels: labelDictionary) {
                return "11 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            print("Load failed for opcode \(opCode)")
            return "00 00 00 00"
            
        case "HL":
            
            if splitParts[1].contains("(") {
                let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = address.validUInt16(labels: labelDictionary){
                    return "2A \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
            if let word = String(splitParts[1]).validUInt16(labels: labelDictionary) {
                return "21 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            
        case "IX":
            
            if splitParts[1].contains("(") {
                let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = address.validUInt16(labels: labelDictionary){
                    return "DD 2A \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
            if let word = String(splitParts[1]).validUInt16(labels: labelDictionary) {
                return "DD 21 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            print("Load failed for opcode \(opCode)")
            return "00 00 00 00"
            
        case "IY":
            
            if splitParts[1].contains("(") {
                let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = address.validUInt16(labels: labelDictionary){
                    return "FD 2A \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
            if let word = String(splitParts[1]).validUInt16(labels: labelDictionary) {
                return "FD 21 \(word.lowByte().hex()) \(word.highByte().hex())"
            }
            
            print("Load failed for opcode \(opCode)")
            return "00 00 00 00"
            
        case "SP":
            
            switch splitParts[1] {
            case "HL":
                return "F9"
            default:
                if let displacement = String(splitParts[1]).displacement(){
                    if splitParts[1].contains("IX+") {
                        return "DD F9 \(displacement)"
                    }
                    if splitParts[1].contains("IY+") {
                        return "FD F9 \(displacement)"
                    }
                }
                if splitParts[1].contains("(") {
                    let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                    if let word = address.validUInt16(labels: labelDictionary){
                        return "ED 7B \(word.lowByte().hex()) \(word.highByte().hex())"
                    }
                }
                if let word = String(splitParts[1]).validUInt16(labels: labelDictionary) {
                    return "31 \(word.lowByte().hex()) \(word.highByte().hex())"
                }
                
                print("Load failed for opcode \(opCode)")
                return "00 00 00 00"
            }
            
            
            
            
            
        default:
            if splitParts[1].contains("(") {
                let address = splitParts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                if let word = address.validUInt16(labels: labelDictionary){
                    return "3A \(word.lowByte().hex()) \(word.highByte().hex())"
                }
            }
            
            print("Load failed for opcode \(opCode)")
            return "00 00 00"
        }
        
        
        
        
        print("LD did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
}

