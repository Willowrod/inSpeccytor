//
//  CodeExtensions.swift
//  inSpeccytor
//
//  Created by Mike Hall on 11/02/2021.
//

import Foundation
import UIKit

extension BaseViewController {
    func c_mainTableViewCell(indexPath: IndexPath) -> MainTableViewCell {
        let row = indexPath.row
        let cell = mainTableView.dequeueReusableCell(withIdentifier: mainCellIdentifier, for: indexPath) as! MainTableViewCell
        let thisLine = self.opCodes[row]
        cell.setDelegate(iD: row, del: self)
        cell.setLineType(type: thisLine.lineType)
        if (thisLine.lineType == .CODE && thisLine.code.count > 0){
        let lineNumber = (baseSelector.selectedSegmentIndex == 0 ? "\(String(thisLine.line, radix: 16).padded(size: 4))" : "\(thisLine.line)")
        var lineNumberID = ""
        cell.byteContent.text = assembler.assemble(opCode: thisLine.code)
        if entryPoints.contains(thisLine.line){
            lineNumberID = "➡️"
        }
        switch (thisLine.targetType){
        case .CODE:
            lineNumberID = "\(lineNumberID)↘️"
        case .RELATIVE:
            lineNumberID = "\(lineNumberID)↕️"
        case .DATA:
            lineNumberID = "\(lineNumberID)#️⃣"
        case .TEXT:
            lineNumberID = "\(lineNumberID)🔤"
        case .GRAPHICS:
            lineNumberID = "\(lineNumberID)🔣"
        default:
            cell.lineNumber.text = "\(lineNumber)"
            break
        }
        cell.lineNumber.text = "\(lineNumberID) \(lineNumber)"
        } else {
            cell.lineNumber.text = "🆕"
            cell.byteContent.text = ""
        }
        cell.opCode.text = thisLine.code
        cell.comment.text = "\(thisLine.meaning)"
        return cell
    }
    
    func c_saveCode() {
        
    }
    
    
    
    func c_run() {
        if let pc = programCounter.text{
            let selectedLine = "\(baseSelector.selectedSegmentIndex == 0 ? "$" : "")\(pc)"
            if let pC = selectedLine.validUInt16(){
                computer?.pause()
            computer?.PC = pC
            var counter = pC
                opCodes.forEach{ opCodeToAdd in
                    opCodeToAdd.opCodeArray.forEach{byte in
                        computer?.ldRam(location: counter, value: byte)
                        counter = counter &+ 1
                    }
                }
                computer?.resume()
            }
        }
    }
}
