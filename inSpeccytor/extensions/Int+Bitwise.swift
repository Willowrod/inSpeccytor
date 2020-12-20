//
//  Int+Bitwise.swift
//  inSpeccytor
//
//  Created by Mike Hall on 15/12/2020.
//

import Foundation
extension Int {
    func isSet(bit: Int) -> Bool {
    return (self & (1 << bit)) > 0
}
}
    
    extension UInt8 {
        func isSet(bit: Int) -> Bool {
        return (self & (1 << bit)) > 0
    }
}
