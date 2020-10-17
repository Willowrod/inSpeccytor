//
//  OpCode.swift
//  inSpeccytor
//
//  Created by Mike Hall on 17/10/2020.
//

import Foundation

struct OpCode {
    var value: String
    var code: String
    var meaning: String
    var length: Int
    var isPreCode: Bool = false
    var isEndOfRoutine: Bool
    
    init(v: String, c: String, m: String, l: Int, e: Bool = false) {
        value = v
        code = c
        meaning = m
        length = l
        isEndOfRoutine = e
        if l == 0 {
            isPreCode = true
        }
    }
    
    func toString() -> String {
        return "\(value):\(code) - \(meaning)"
    }
}
