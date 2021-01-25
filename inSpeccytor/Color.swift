//
//  Color.swift
//  inSpeccytor
//
//  Created by Mike Hall on 14/12/2020.
//

import Foundation
import UIKit
struct Color {
    var r, g, b: UInt8
    var a: UInt8 = 255
}

extension Color {
    static let black = Color(r: 0, g: 0, b: 0)
    static let blue = Color(r: 0, g: 0, b: 215)
    static let red = Color(r: 215, g: 0, b: 0)
    static let magenta = Color(r: 215, g: 0, b: 215)
    static let green = Color(r: 0, g: 215, b: 0)
    static let cyan = Color(r: 0, g: 215, b: 215)
    static let yellow = Color(r: 215, g: 215, b: 0)
    static let white = Color(r: 215, g: 215, b: 215)
    
    static let bright_black = Color(r: 0, g: 0, b: 0)
    static let bright_blue = Color(r: 0, g: 0, b: 255)
    static let bright_red = Color(r: 255, g: 0, b: 0)
    static let bright_magenta = Color(r: 255, g: 0, b: 225)
    static let bright_green = Color(r: 0, g: 255, b: 0)
    static let bright_cyan = Color(r: 0, g: 255, b: 255)
    static let bright_yellow = Color(r: 0, g: 255, b: 255)
    static let bright_white = Color(r: 255, g: 255, b: 255)
    
    func toUIColor() -> UIColor{
        let red: CGFloat = CGFloat(r) / 255.0
        let green: CGFloat = CGFloat(g) / 255.0
        let blue: CGFloat = CGFloat(b) / 255.0
        let alpha: CGFloat = CGFloat(a) / 255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


