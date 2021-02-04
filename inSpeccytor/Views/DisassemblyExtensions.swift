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
        let lineNumber = (isHex() ? "\(String(thisLine.line, radix: 16).padded(size: 4))" : "\(thisLine.line)")
        var lineNumberID = ""
        cell.byteContent.text = assembler.assemble(opCodeModel: thisLine)
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
    
    func d_saveCode(){
        let alert = UIAlertController(title: "Disassembly name", message: "Please enter a file name to save this disassembly", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.current_d_filename
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.d_saveCode(fileName: textField.text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func d_saveCode(fileName: String) {
        if opCodes.isEmpty {
            return
        }
        var listing = CodeListing()
        listing.opCodes = opCodes
            opCodes.forEach{ opCodeToAdd in
                opCodeToAdd.opCodeArray.forEach{byte in
                    listing.listing.append(byte)
                }
            }
        
        listing.startLine = UInt16(opCodes[0].line)
        do{
        let success = try SaveLoad.instance.save(jsonObject: listing, toFilename: "TestListing2")
        print("Save succeeded? \(success)")
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
        
    }
    
    func d_loadCode() {
            SaveLoad.instance.load(filename: "TestListing2")
    }
    
    func d_codeLoaded(listing: CodeListing){
        print("File loaded in Disassembler")
                    opCodes = listing.opCodes
                    refreshTables()
    }
    
    func d_run() {
        if let computer = computer {
        computer.writeCodeBytes()
        stopAfterEachOpCode = false
        updatePC()
            let jumpPoints = computer.jumpPoints.map{Int($0)}
        print("Disassembly from PC at \(String(pCInDisAssembler, radix: 16))")
            _ = Z80Disassembler.init(withData: computer.memoryDump(withRom: true), knownJumpPoints: jumpPoints, fromPC: pCInDisAssembler, delegate: self, shouldIncludeRom: false)
        }
    }
}
