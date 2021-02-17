//
//  DisassemblyExtensions.swift
//  inSpeccytor
//
//  Created by Mike Hall on 11/02/2021.
//

import Foundation
import UIKit

extension BaseViewController {
    
    func d_mainTableViewCell( indexPath: IndexPath) -> MainTableViewCell {
        let row = indexPath.row
        let cell = mainTableView.dequeueReusableCell(withIdentifier: mainCellIdentifier, for: indexPath) as! MainTableViewCell
        let thisLine = self.opCodes[row]
        cell.setDelegate(iD: row, del: self)
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
        cell.opCode.text = thisLine.code
        cell.comment.text = "\(thisLine.meaning)"
        return cell
    }
    
    func d_saveCode() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
        let data = try encoder.encode(opCodes)
        print(String(data: data, encoding: .utf8)!)
        } catch {
            print(error)
        }
    }
    
    func d_run() {
        computer?.writeCodeBytes()
        stopAfterEachOpCode = false
        updatePC()
        print("Disassembly from PC at \(String(pCInDisAssembler, radix: 16))")
        parseLine()
    }
}
