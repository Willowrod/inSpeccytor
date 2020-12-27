//
//  UInt16+Bitwise.swift
//  inSpeccytor
//
//  Created by Mike Hall on 27/12/2020.
//

import Foundation

extension UInt16 {
    func highBit() -> UInt8 {
        return UInt8(self / 256)
    }
    
    func lowBit() -> UInt8 {
       return UInt8(self - ((self / 256) * 256))
    }
}
