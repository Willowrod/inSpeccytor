//
//  Z80Assembler+Logic.swift
//  inSpeccytor
//
//  Created by Mike Hall on 09/02/2021.
//

import Foundation

extension Z80Assembler {
    func and(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "A6"
        }
        if let offset = secondPart.regOffset() {
            return (0xA0 &+ offset).hex()
        }

            
            if let offset = secondPart.validUInt8() {
                return "E6 \(offset.hex())"
            }
            if let displacement = secondPart.displacement(){
                if secondPart.contains("IX+") {
                    return "DD A6 \(displacement)"
                }
                if secondPart.contains("IY+") {
                    return "FD A6 \(displacement)"
                }
            }
            
        print("AND did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func or(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "B6"
        }
        if let offset = secondPart.regOffset() {
            return (0xB0 &+ offset).hex()
        }

            
            if let offset = secondPart.validUInt8() {
                return "F6 \(offset.hex())"
            }
            if let displacement = secondPart.displacement(){
                if secondPart.contains("IX+") {
                    return "DD B6 \(displacement)"
                }
                if secondPart.contains("IY+") {
                    return "FD B6 \(displacement)"
                }
            }
            
        print("OR did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func xor(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "AE"
        }
        if let offset = secondPart.regOffset() {
            return (0xA8 &+ offset).hex()
        }

            
            if let offset = secondPart.validUInt8() {
                return "EE \(offset.hex())"
            }
            if let displacement = secondPart.displacement(){
                if secondPart.contains("IX+") {
                    return "DD AE \(displacement)"
                }
                if secondPart.contains("IY+") {
                    return "FD AE \(displacement)"
                }
            }
            
        print("XOR did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
}
