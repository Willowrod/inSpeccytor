//
//  OpCode.swift
//  inSpeccytor
//
//  Created by Mike Hall on 17/10/2020.
//

import Foundation

struct OpCode {
    var line: Int = 0
    var target: Int = 0
    var value: String
    var code: String
    var meaning: String
    var length: Int
    var isPreCode: Bool = false
    var isEndOfRoutine: Bool
    var targetType: TargetType.TypeOfTarget
    var lineType: TargetType.TypeOfTarget = .NOTARGET
    var isJumpPosition = false
    
    init(v: String, c: String, m: String, l: Int, e: Bool = false, t: TargetType.TypeOfTarget = .NOTARGET) {
        value = v
        code = c
        meaning = m
        length = l
        isEndOfRoutine = e
        if l == 0 {
            isPreCode = true
        }
        targetType = t
    }
    
    func toString() -> String {
        return "\(value):\(code) - \(meaning)"
    }
}
