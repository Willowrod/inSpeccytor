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
        var thisLine = self.opCodes[row]
        cell.setDelegate(iD: row, del: self)
        cell.setLineType(type: thisLine.lineType)
        if (thisLine.lineType == .CODE && thisLine.code.count > 0){
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
        } else {
            cell.lineNumber.text = "🆕"
            cell.byteContent.text = ""
        }
        cell.opCode.text = thisLine.code
        cell.comment.text = "\(thisLine.meaning)"
        if thisLine.shouldAutoFocus {
            thisLine.shouldAutoFocus = false
            cell.opCode.becomeFirstResponder()
        }
        return cell
    }
    
    func c_saveCode(fileName: String) {
        if opCodes.isEmpty {
            return
        }
        setInitialPC()
        var listing = CodeListing()
        listing.opCodes = opCodes
            opCodes.forEach{ opCodeToAdd in
                opCodeToAdd.opCodeArray.forEach{byte in
                    listing.listing.append(byte)
                }
            }
        
        listing.startLine = codeStart
        do{
        let success = try SaveLoad.instance.save(jsonObject: listing, toFilename: fileName)
        print("Save succeeded? \(success)")
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
    
    func c_loadCode(fileName: String) {
            SaveLoad.instance.load(filename: fileName)
    }
    
    
    func c_codeLoaded(listing: CodeListing){
        print("File loaded in Code")
        opCodes = listing.opCodes
        updatePCUI(pc: codeStart)
        refreshTables()
    }
    
    
    func c_run() {
        
        computer?.pause()
        
        c_saveCode(fileName: "tempBackup")
        assembler.labelDictionary.removeAll()
        setInitialPC()
        addLabels()
        parseLabels()
            var counter = codeStart
                opCodes.forEach{ opCodeToAdd in
                    opCodeToAdd.opCodeArray.forEach{byte in
                        computer?.ldRam(location: counter, value: byte)
                        counter = counter &+ 1
                    }
                }
        
        computer?.PC = codeStart
        computer?.resume()
        
    }
    
    func setInitialPC(){
        if let pc = programCounter.text{
            let selectedLine = "\(isHex() ? "$" : "")\(pc)"
            if let pC = selectedLine.validUInt16(labels: nil), pC > 0x4000{
                codeStart = pC
                return
            }
        }
        codeStart = 0x8000
        updatePCUI(pc: codeStart)
    }
    
    func addLabels(){
        var currentLine = Int(codeStart)
           // opCodes.forEach{ opCodeToAdd in
        for index in 0..<opCodes.count {
                opCodes[index].line = currentLine
            if !opCodes[index].label.isEmpty{
                addLabelToDictionary(label: opCodes[index].label.uppercased(), line: currentLine)
            }
                opCodes[index].opCodeArray.forEach{byte in
                    currentLine += 1
                }
            }
    }
    
    func addLabelToDictionary(label: String, line: Int){
        if assembler.labelDictionary[label] != nil {
            print("‼️ Label \(label) already exists")
        } else {
            assembler.labelDictionary[label] = line
        }
    }
    
    func parseLabels(){
        for index in 0..<opCodes.count {
            if (!opCodes[index].code.isEmpty){
            opCodes[index].writeOpCode(oC: assembler.assemble(opCodeModel: opCodes[index]))
            }
            }
    }
}
