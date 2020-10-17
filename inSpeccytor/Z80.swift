//
//  Z80.swift
//  inSpeccytor
//
//  Created by Mike Hall on 17/10/2020.
//

import Foundation

class Z80 {
    
    func opCode(code: String) -> OpCode {
        
        switch(code.uppercased()){
        case "00":
            return OpCode(v: code, c: "NOP", m: "No Operation", l: 1)
        case "01":
            return OpCode(v: code, c: "LD BC,$$", m: "Load register pair BC with the value $$", l: 3)
        case "02":
            return OpCode(v: code, c: "LD (BC),A", m: "Load the contents of the memory address stored in BC with the value of register A", l: 1)
            
        case "18":
            return OpCode(v: code, c: "JR $$", m: "Jump to routine at memory offset +$$", l: 2, e: true)
            
        case "21":
            return OpCode(v: code, c: "LD HL,$$", m: "Load the register pair HL with the value $$", l: 3)
            
            
        case "28":
            return OpCode(v: code, c: "JR Z, $$", m: "If the Zero flag is set in register F, jump to routine at memory location $$ - Relative jump", l: 3)
            
        case "3E":
            return OpCode(v: code, c: "LD A,$$", m: "Load register A with the value $$", l: 2)
            
        case "47":
            return OpCode(v: code, c: "LD B,A", m: "Load register B with the value of register A", l: 1)
            
        case "78":
            return OpCode(v: code, c: "LD A,B", m: "Load register A with the value of register B", l: 1)
            
        case "C3":
            return OpCode(v: code, c: "JP $$", m: "Jump to routine at memory location $$", l: 3, e: true)
            
        case "CA":
            return OpCode(v: code, c: "JP Z, $$", m: "If the Zero flag is set in register F, jump to routine at memory location $$", l: 3)
        case "CB":
            return OpCode(v: code, c: "PreCode", m: "", l: 0)
            
        case "DB":
            return OpCode(v: code, c: "IN A,($$)", m: "Load register A with an input defined by the current value of A from port $$ (Generally keyboard input) ", l: 2)
            
        case "DD":
            return OpCode(v: code, c: "PreCode", m: "", l: 0)
            
        case "E6":
            return OpCode(v: code, c: "AND $$", m: "Update A to only contain bytes set in both A and the value $$", l: 2)
            
        case "ED":
            return OpCode(v: code, c: "PreCode", m: "", l: 0)
            
        case "FD":
            return OpCode(v: code, c: "PreCode", m: "", l: 0)
            
            //DD Op codes
        case "DD21":
            return OpCode(v: code, c: "LD IX,$$", m: "Load the memory location IX with the value $$", l: 3)
        case "DD36":
            return OpCode(v: code, c: "LD (IX+$1),$2", m: "Load the contents of the memory address stored in (IX + $1) with the value $2", l: 3)
            
            
            
            
        default:
            return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1, e: true)

        }
        
    }
    
    
    
    
    func opCode(preCode: String, code: String) -> OpCode {
        
        switch (preCode.uppercased()) {
        case "CB":
            switch (code.uppercased()) {
            default:
                return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1)
            }
        case "DD":
            switch (code.uppercased()) {
            case "21":
                return OpCode(v: code, c: "LD IX,$$", m: "Load the memory location IX with the value $$", l: 3)
            case "36":
                return OpCode(v: code, c: "LD (IX+$1),$2", m: "Load the contents of the memory address stored in (IX + $1) with the value $2", l: 3)
            default:
                return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1)
            }
        case "ED":
            switch (code.uppercased()) {
            default:
                return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1)
            }
        case "FD":
            switch (code.uppercased()) {
            default:
                return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1)
            }
        default:
            return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1)
        }
        
        
        
        return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1)
    }
    
}
