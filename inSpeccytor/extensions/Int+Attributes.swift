//
//  Int+Attributes.swift
//  inSpeccytor
//
//  Created by Mike Hall on 15/12/2020.
//

import Foundation
extension Int {
    func ink() -> Color {
        let bright = self & 6 == 1
        switch (self & 0b00000111){
        case 0:
            return Color.black
        case 1:
            return bright ? Color.bright_blue : Color.blue
        case 2:
            return bright ? Color.bright_red : Color.red
        case 3:
            return bright ? Color.bright_magenta : Color.magenta
        case 4:
            return bright ? Color.bright_green : Color.green
        case 5:
            return bright ? Color.bright_cyan : Color.cyan
        case 6:
            return bright ? Color.bright_yellow : Color.yellow
        case 7:
            return bright ? Color.bright_white : Color.white
        default:
            return Color.black
        }
}
    func paper() -> Color {
        let bright = self & 6 == 1
        switch ((self & 0b00111000) >> 3){
        case 0:
            return Color.black
        case 1:
            return bright ? Color.bright_blue : Color.blue
        case 2:
            return bright ? Color.bright_red : Color.red
        case 3:
            return bright ? Color.bright_magenta : Color.magenta
        case 4:
            return bright ? Color.bright_green : Color.green
        case 5:
            return bright ? Color.bright_cyan : Color.cyan
        case 6:
            return bright ? Color.bright_yellow : Color.yellow
        case 7:
            return bright ? Color.bright_white : Color.white
        default:
            return Color.black
        }
}
    
  

}

extension UInt8 {
    func ink() -> Color {
        let bright = self & 6 == 1
        switch (self & 0b00000111){
        case 0:
            return Color.black
        case 1:
            return bright ? Color.bright_blue : Color.blue
        case 2:
            return bright ? Color.bright_red : Color.red
        case 3:
            return bright ? Color.bright_magenta : Color.magenta
        case 4:
            return bright ? Color.bright_green : Color.green
        case 5:
            return bright ? Color.bright_cyan : Color.cyan
        case 6:
            return bright ? Color.bright_yellow : Color.yellow
        case 7:
            return bright ? Color.bright_white : Color.white
        default:
            return Color.black
        }
}
    func paper() -> Color {
        let bright = self & 6 == 1
        switch ((self & 0b00111000) >> 3){
        case 0:
            return Color.black
        case 1:
            return bright ? Color.bright_blue : Color.blue
        case 2:
            return bright ? Color.bright_red : Color.red
        case 3:
            return bright ? Color.bright_magenta : Color.magenta
        case 4:
            return bright ? Color.bright_green : Color.green
        case 5:
            return bright ? Color.bright_cyan : Color.cyan
        case 6:
            return bright ? Color.bright_yellow : Color.yellow
        case 7:
            return bright ? Color.bright_white : Color.white
        default:
            return Color.black
        }
}
}
