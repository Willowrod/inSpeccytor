//
//  Z80.swift
//  inSpeccytor
//
//  Created by Mike Hall on 17/10/2020.
//

import Foundation

class Z80 {
    
    func opCode(code: String) -> OpCode {
        
        switch(code){
        case "78":
            return OpCode(v: code, c: "LD A,B", m: "Load register A with the value of Register B", l: 1)
        
        default:
            return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1)

        }
        
    }
    
    
    
    
    func opCode(preCode: String, code: String) -> OpCode {
        
        
        return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1)
    }
    
}
