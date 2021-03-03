//
//  Z80Assembler+Bitwise.swift
//  inSpeccytor
//
//  Created by Mike Hall on 09/02/2021.
//

import Foundation
extension Z80Assembler {
    
    func bit(secondPart: String, opCode: String) -> String {
        let split = secondPart.split(separator: ",")
        if split.count == 2{
            if let multiplier = String(split[0]).validUInt8(){
                let multiplierOffset = multiplier &* 0x08
            if let offset = String(split[1]).regOffset() {
                return "CB \((0x40 &+ offset &+ multiplierOffset).hex())"
            }
            
            if split[1] == "(HL)" {
                return "CB \((0x46 &+ multiplierOffset).hex())"
            }
            if let displacement = String(split[1]).displacement(){
                if split[1].contains("IX+") {
                    return "DD CB \(displacement) \((0x46 &+ multiplierOffset).hex())"
                }
                if split[1].contains("IY+") {
                    return "FD CB \(displacement) \((0x46 &+ multiplierOffset).hex())"
                }
            }
            }
            
        }
            
        print("BIT did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func set(secondPart: String, opCode: String) -> String {
        let split = secondPart.split(separator: ",")
        if split.count == 2{
            if let multiplier = String(split[0]).validUInt8(){
                let multiplierOffset = multiplier &* 0x08
            if let offset = String(split[1]).regOffset() {
                return "CB \((0xC0 &+ offset &+ multiplierOffset).hex())"
            }
            
            if split[1] == "(HL)" {
                return "CB \((0xC6 &+ multiplierOffset).hex())"
            }
            if let displacement = String(split[1]).displacement(){
                if split[1].contains("IX+") {
                    return "DD CB \(displacement) \((0xC6 &+ multiplierOffset).hex())"
                }
                if split[1].contains("IY+") {
                    return "FD CB \(displacement) \((0xC6 &+ multiplierOffset).hex())"
                }
            }
            }
            
        }
            
        print("SET did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func res(secondPart: String, opCode: String) -> String {
        let split = secondPart.split(separator: ",")
        if split.count == 2{
            if let multiplier = String(split[0]).validUInt8(){
                let multiplierOffset = multiplier &* 0x08
            if let offset = String(split[1]).regOffset() {
                return "CB \((0x80 &+ offset &+ multiplierOffset).hex())"
            }
            
            if split[1] == "(HL)" {
                return "CB \((0x86 &+ multiplierOffset).hex())"
            }
            if let displacement = String(split[1]).displacement(){
                if split[1].contains("IX+") {
                    return "DD CB \(displacement) \((0x86 &+ multiplierOffset).hex())"
                }
                if split[1].contains("IY+") {
                    return "FD CB \(displacement) \((0x86 &+ multiplierOffset).hex())"
                }
            }
            }
            
        }
            
        print("RES did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    
}
