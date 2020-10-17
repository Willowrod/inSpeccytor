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
    
    init(v: String, c: String, m: String, l: Int) {
        value = v
        code = c
        meaning = m
        length = l
        if l == 0 {
            isPreCode = true
        }
    }
    
    func toString() -> String {
        return "\(code) - \(meaning)"
    }
}
