//
//  BaseViewController.swift
//  inSpeccytor
//
//  Created by Mike Hall on 12/01/2021.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Z80Delegate {
    @IBOutlet weak var screenRender: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var hexView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var programCounter: UITextField!
    @IBOutlet weak var jumpBox: UITextField!
    @IBOutlet weak var baseSelector: UISegmentedControl!
    
    
    
    let pCOffset = 16384 - 27
    let lineCellIdentifier = "lineCell"
    let mainCellIdentifier = "codeCell"
    var model: Array<CodeByteModel> = []
    var opCodes: Array<OpCode> = []
    var header: RegisterModel = RegisterModel()
    var stopAfterEachOpCode = false
    var shouldDisplayScreen = false
    let borderX = 0 //32
    let borderY = 0 //24
    let z80 = Z80()
    let opcodeLookup = OpCodeDefs()
    var frames = 1
    var seconds = 1
    var lastcount = 0
    var lastFlashChange = 0.0
    var flashOn = false
    var useHexValues = false
    var lastSecond: TimeInterval = Date.init().timeIntervalSince1970
    var pCInDisAssembler = 0

    var entryPoints: [Int] = []
    var alreadyAdded: [Int] = []
    var currentEntryPoint = 0
    var isCalc = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        z80.delegate = self
        screenRender.setUpImageView()

        bootEmulator()
    }
    
    func bootEmulator(){
        loadROM()
     //  loadSnapshot(sna: "dizzy_fw")
        // loadSnapshot(sna: "actionbiker")
        loadZ80(z80Snap: "middleoflakecheat")
        startProcessor()
    }
    
    func loadROM(){
        if let filePath = Bundle.main.path(forResource: "48k", ofType: "rom"){
            print("File found - \(filePath)")
            let contents = NSData(contentsOfFile: filePath)
            let data = contents! as Data
            let dataString = data.hexString
            expandROM(data: dataString)
        } else {
            fileName.text = "ROM failed to load"
            hexView.text = "- - - - - - - -"
            print("file not found")
        }
        writeCodeBytes()
    }
    
    func expandROM(data: String?){
        if let dataModel = data?.splitToBytesROM(separator: " "){
          //  self.model = dataModel
            z80.writeRAM(dataModel: dataModel)
        } else {
            fileName.text = "Failed to create ROM"
        }
    }
    
    func startProcessor(){
        DispatchQueue.background(background: {
            self.z80.process()
        }, completion:{
            // when background job finished, do something in main thread
        })
    }
    
    func keyboardInteraction(key: Int, pressed: Bool){
        var bank = -1
        var bit = -1
        switch key{
        case 4: // a
            bank = 6
            bit = 0
        case 5: // b
            bank = 0
            bit = 4
        case 6: // c
            bank = 7
            bit = 3
        case 7: // d
            bank = 6
            bit = 2
        case 8: // e
            bank = 5
            bit = 2
        case 9: // f
            bank = 6
            bit = 3
        case 10: // g
            bank = 6
            bit = 4
        case 11: // h
            bank = 1
            bit = 4
        case 12: // i
            bank = 2
            bit = 2
        case 13: // j
            bank = 1
            bit = 3
        case 14: // k
            bank = 1
            bit = 2
        case 15: // l
            bank = 1
            bit = 1
        case 16: // m
            bank = 0
            bit = 2
        case 17: // n
            bank = 0
            bit = 3
        case 18: // o
            bank = 2
            bit = 1
        case 19: // p
            bank = 2
            bit = 0
        case 20: // q
            bank = 5
            bit = 0
        case 21: // r
            bank = 5
            bit = 3
        case 22: // s
            bank = 6
            bit = 1
        case 23: // t
            bank = 5
            bit = 4
        case 24: // u
            bank = 2
            bit = 3
        case 25: // v
            bank = 7
            bit = 4
        case 26: // w
            bank = 5
            bit = 1
        case 27: // x
            bank = 7
            bit = 2
        case 28: // y
            bank = 2
            bit = 4
        case 29: // z
            bank = 7
            bit = 1
        case 30: // 1
            bank = 4
            bit = 0
        case 31: // 2
            bank = 4
            bit = 1
        case 32: // 3
            bank = 4
            bit = 2
        case 33: // 4
            bank = 4
            bit = 3
        case 34: // 5
            bank = 4
            bit = 4
        case 35: // 6
            bank = 3
            bit = 4
        case 36: // 7
            bank = 3
            bit = 3
        case 37: // 8
            bank = 3
            bit = 2
        case 38: // 9
            bank = 3
            bit = 1
        case 39: // 0
            bank = 3
            bit = 0
        case 40: // enter
            bank = 1
            bit = 0
        case 44: // space
            bank = 0
            bit = 0
        case 225: // LShift (CS)
            bank = 7
            bit = 0
        case 224: // LCnt (SS)
            bank = 0
            bit = 1
            
        default:
            bank = -1
            bit = -1
        }
        if bank >= 0 && bit >= 0 {
            pressed ? z80.keyboard[bank].clear(bit: bit) : z80.keyboard[bank].set(bit: bit)
        }
    }
    
    func joystickInteraction(key: Int, pressed: Bool){
        // Kempston 000FUDLR
        switch key{
        case 1: // Left
            pressed ? z80.kempston.set(bit: 1) : z80.kempston.clear(bit: 1)
        case 2: // Right
            pressed ? z80.kempston.set(bit: 0) : z80.kempston.clear(bit: 0)
        case 3: // Up
            pressed ? z80.kempston.set(bit: 3) : z80.kempston.clear(bit: 3)
        case 4: // Down
            pressed ? z80.kempston.set(bit: 2) : z80.kempston.clear(bit: 2)
        case 5: // LFire
            pressed ? z80.kempston.set(bit: 4) : z80.kempston.clear(bit: 4)
        case 6: // RFire
            pressed ? z80.kempston.set(bit: 4) : z80.kempston.clear(bit: 4)
        default:
         break
        }
        
        
    }
    
    func load(file: String){
       var fileStruct = file.split(separator: ".")
        
        if fileStruct.count > 1{
            let fileType = fileStruct.last
            fileStruct.removeLast()
            let name = fileStruct.joined(separator: ".")
            self.fileName.text = name
            switch fileType {
            case "sna":
                loadSnapshot(sna: name)
            case "z80":
                loadZ80(z80Snap: name)
            case "tzx":
                importTZX(tzxFile: name)
            default:
                print("Unknown file type = \(file)")
            }
        } else {
            print("Unknown or bad file = \(file)")
        }
    }
    
    func loadSnapshot(sna: String){
            let snapShot = SNAFormat(fileName: sna)
        z80.writeRAM(dataModel: snapShot.ramBanks[0], startAddress: 16384)
        z80.initialiseRegisters(header: snapShot.registers)
        header = snapShot.registers
        writeCodeBytes()
    }
    
    func loadZ80(z80Snap: String){
        let snapShot = Z80Format(fileName: z80Snap)
        z80.writeRAM(dataModel: snapShot.retrieveRam(), startAddress: 16384)
    z80.initialiseRegisters(header: snapShot.registers)
        header = snapShot.registers
        writeCodeBytes()
    }
    
    func importTZX(tzxFile: String){
        if let filePath = Bundle.main.path(forResource: tzxFile, ofType: "tzx"){
            print("File found - \(filePath)")
            if let index = filePath.lastIndex(of: "/"){
                let name = filePath.substring(from: index)
                fileName.text = name
            } else {
                fileName.text = "Unknown Snapshot"
                hexView.text = "- - - - - - - -"
            }
            let contents = NSData(contentsOfFile: filePath)
            let data = contents! as Data
            let dataString = data.hexString
            let tzx = TZXFormat.init(data: dataString)
        } else {
            fileName.text = "Snapshot failed to load"
            hexView.text = "- - - - - - - -"
            print("file not found")
        }
    }
    
    func updateFPS(){
        let timestamp = Date.init().timeIntervalSince1970
        if timestamp > lastSecond + 1 {
            lastSecond = timestamp
            seconds += 1
            hexView.text = "FPS: \(frames / seconds) in \(seconds) seconds"
        }
        frames += 1
    }
    
    func writeCodeBytes(){
        model.removeAll()
        var id = 0
        z80.ram.forEach{byte in
            model.append(byte.createCodeByte(lineNumber: id))
            id += 1
        }
    }
    
    // Disassembler
    
    func updatePC(){
        if let pc = programCounter.text, pc.count == 5, let pcUint = Int(pc) {
            pCInDisAssembler = pcUint
        } else {
            pCInDisAssembler = Int(header.registerPC)
        }
        entryPoints.removeAll()
        entryPoints.append(pCInDisAssembler)
        currentEntryPoint = 0
        
    }

    func updatePCUI(){
        programCounter.text = "\(pCInDisAssembler)"
        if (pCInDisAssembler < model.count){
            let targetRowIndexPath = IndexPath(row: pCInDisAssembler, section: 0)
            tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
        }
    }

    func updatePCUI(pc: Int){
        programCounter.text = "\(pc)"
        let modelPosition = pc - pCOffset
        if (modelPosition < model.count){
            let targetRowIndexPath = IndexPath(row: modelPosition, section: 0)
               tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
        }
    }

    func getCodeByte() -> CodeByteModel {
        let modelPosition = Int(pCInDisAssembler)
        if (modelPosition < model.count){
            return model[modelPosition]
        } else {
            return model.first ?? CodeByteModel(withHex: "00", line: modelPosition)
        }
    }

    func getCodeByteValue(position: Int) -> Int {
        let modelPosition = position // - pCOffset
        if (modelPosition < model.count){
            return model[modelPosition].intValue
        }
        return 0
    }

    func parseLine(){
        var runLoop = true
        while runLoop{
            let lineAsInt = pCInDisAssembler
            if pCInDisAssembler == 0xD858 {
                print ("Debug here!")
            }
            var opCode = opcodeLookup.opCode(code: getCodeByte().hexValue)
            pCInDisAssembler += 1
            if (!isCalc){
            if opCode.isPreCode {
                let thisCode = getCodeByte().hexValue
                pCInDisAssembler += 1
                opCode = opcodeLookup.opCode(code: "\(opCode.value)\(thisCode)", extra: getCodeByte().hexValue)
            }
            if opCode.length == 2 {
                let byte: UInt8 = UInt8(getCodeByte().intValue)
                if opCode.code.contains("±"){
                    opCode.code = opCode.code.replacingOccurrences(of: "±", with: "\(byte) - \(UInt8(byte).hex().padded(size: 2))")
                } else if opCode.code.contains("$$"){
                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(byte) - \(UInt8(byte).hex().padded(size: 2))")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(byte)")
                    //opCode.code = "###\(opCode.code)"
                } else if opCode.code.contains("##"){ // Two's compliment
                    let subt = byte.isSet(bit: 7)
                    var comp: Int = -Int(byte.twosCompliment())
                    if !subt{
                        comp = Int(byte)
                    }
                    opCode.target = pCInDisAssembler + comp + 1 //Add 1 to make PC correct before comp
                    if opCode.target > 0xffff {
                        opCode.code = opCode.code.replacingOccurrences(of: "##", with: "\(opCode.target) - OVERFLOW!")
                    } else {
                    opCode.code = opCode.code.replacingOccurrences(of: "##", with: "\(opCode.target) - \(UInt16(opCode.target).hex().padded(size: 4))")
                    }
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "##", with: "\(comp)")
                } else if opCode.code.contains("§§"){ // Two's compliment
                    let subt = byte.isSet(bit: 7)
                    var comp: Int = -Int(byte.twosCompliment())
                    if !subt{
                        comp = Int(byte)
                    }
                    opCode.target = pCInDisAssembler + comp + 1 //Add 1 to make PC correct before comp
                    opCode.code = opCode.code.replacingOccurrences(of: "§§", with: "\(comp)")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "§§", with: "\(comp)")
                }

                opCode.meaning = opCode.meaning.replacingOccurrences(of: "±", with: "\(byte)")
                pCInDisAssembler += 1
            } else if opCode.length == 3 {
                let low = getCodeByte().intValue
                pCInDisAssembler += 1
                let high = getCodeByte().intValue

                if (opCode.code.contains("$$")){
                    let word = (high * 256) + low
                    opCode.target = word
                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(word) - \(UInt16(word).hex().padded(size: 4))")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(word)")
                } else {
                    opCode.code = opCode.code.replacingOccurrences(of: "$1", with: "\(low)").replacingOccurrences(of: "$2", with: "\(high)")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$1", with: "\(low)").replacingOccurrences(of: "$2", with: "\(high)")
                }
                pCInDisAssembler += 1
            }
                opCode.line = Int(lineAsInt)
            if (!alreadyAdded.contains(opCode.line)){
            opCodes.append(opCode)
                alreadyAdded.append(opCode.line)
            }
            
            if (opCode.isJumpTarget()){
                if opCode.targetType == .RST {
                    switch opCode.value.uppercased() {
                    case "C7":
                        opCode.target = 0
                    case "CF":
                        opCode.target = 0x08
                    case "D7":
                        opCode.target = 0x10
                    case "DF":
                        opCode.target = 0x18
                    case "E7":
                        opCode.target = 0x20
                    case "EF":
                        opCode.target = 0x28
                    case "F7":
                        opCode.target = 0x30
                    case "FF":
                        opCode.target = 0x38
                    default:
                        opCode.target = 0
                    }
                }
                
                if (!entryPoints.contains(opCode.target) && !alreadyAdded.contains(opCode.target)){
                        print("Adding jump to \(String(opCode.target, radix: 16)) from \(String(opCode.line, radix: 16))")
                    entryPoints.append(opCode.target)
                }
            }
            
            
            if opCode.value.count == 6 {
                pCInDisAssembler += 1
            }
            
                if opCode.value.uppercased() == "EF" {
                    isCalc = true
                }
            
      //                  print("\(UInt16(lineAsInt).hex()): \(opCode.toString())")
                    if (opCode.isEndOfRoutine){
                        if (stopAfterEachOpCode){
                            runLoop = false
                            updatePCUI()
                            opCodes.sort{$0.line < $1.line}
                            mainTableView.reloadData()
                        } else {
                         //   print(" ---------------------- ")
//                            opCodes.sort{$0.line < $1.line}
//                            mainTableView.reloadData()
                        runLoop = sortNextOpCode()
                        }
                    }

            if (pCInDisAssembler >= model.count){
                //             print("End Of File")
//                runLoop = false
//                //header.registerPC -= 1
//                updatePCUI()
//                opCodes.sort{$0.line < $1.line}
//                mainTableView.reloadData()
 //              markPositions()
                runLoop = sortNextOpCode()
            }
            } else {
                if opCode.value.uppercased() == "38"{
                    opCode.code = "End Calc"
                    isCalc = false
                } else if opCode.value.uppercased() == "3B"{
                    opCode.code = "Single Calc Function"
                    isCalc = false
                } else {
                    opCode.code = "Calc \(opCode.code)"
                }
                opCode.line = Int(lineAsInt)
                if (!alreadyAdded.contains(opCode.line)){
                    opCode.meaning = "Calculator Function"
                opCodes.append(opCode)
                    alreadyAdded.append(opCode.line)
                }
            }
        }
        
        opCodes.sort{$0.line < $1.line}
        mainTableView.reloadData()
    }
    
    func sortNextOpCode() -> Bool {
        currentEntryPoint += 1
        while currentEntryPoint < entryPoints.count {
            let nextEP = entryPoints[currentEntryPoint]
            if nextEP > 0xffff {
                print("Bad EP \(String(nextEP, radix: 16))")
                return false
            } else if nextEP < 0x4000 {
                
                } else if !alreadyAdded.contains(nextEP){
            pCInDisAssembler = entryPoints[currentEntryPoint]
            return true
            }
            currentEntryPoint += 1
        }
        print("Processing completed")
        return false
    }
    
    func markPositions(){
        let tempCodes = opCodes
        tempCodes.forEach({ opCode in
            if (opCode.target > 0){
                if let target = self.opCodes.firstIndex(where: {$0.line == opCode.target}) {
                    // print("Target: \(target.line) is jump position")
                    //                    let jumpPos = opCodes[target]
                    //                    print("Target: \(jumpPos.line) is jump position")
                    //opCodes[target].isJumpPosition = true
                    opCodes[target].lineType = opCode.targetType
                }
            }
        })
        mainTableView.reloadData()
    }

    
    // Delegates
    
    // Z80 Delegate
    
    
    
    func updateRegisters() {
        
    }
    
    func updateView(bitmap: Bitmap?) {
        updateFPS()
        if let bitmap = bitmap{
           screenRender.image = (UIImage(bitmap: bitmap))
        }
        updateRegisters()
    }
    
    
    func updateDebug(line: UInt16){
        var targLine = Int(line) - 4
        if targLine < 0 {
            targLine = 0
        }
        guard let index = model.firstIndex(where: {$0.lineNumber == targLine}) else { return }
        let targetRowIndexPath = IndexPath(row: index, section: 0)
        tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
    }
    
    
    
    // Tables
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == mainTableView){
            return self.opCodes.count
        }
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if (tableView == mainTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: mainCellIdentifier, for: indexPath) as! MainTableViewCell
            let thisLine = self.opCodes[row]
            let lineNumber = (baseSelector.selectedSegmentIndex == 0 ? "\(String(thisLine.line, radix: 16).padded(size: 4))" : "\(thisLine.line)")
            var lineNumberID = ""
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
            cell.meaning.text = "\(thisLine.meaning)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: lineCellIdentifier, for: indexPath) as! LineTableViewCell
            let thisLine = self.model[row]
            if baseSelector.selectedSegmentIndex == 0 {
            cell.lineNumber.text = "\(String(thisLine.lineNumber, radix: 16))"
            } else {
                cell.lineNumber.text = "\(thisLine.lineNumber)"
                }
            cell.hexValue.text = thisLine.hexValue
            cell.intValue.text = "\(thisLine.intValue)"
            let breakPoint = UInt16(thisLine.lineNumber)
            if (z80.breakPoints.contains(breakPoint)){
                cell.backgroundColor = UIColor.yellow
            } else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == mainTableView){
            let row = indexPath.row
            let thisLine = self.opCodes[row]
            if (thisLine.target > 0){
                if let target = self.opCodes.firstIndex(where: {$0.line == thisLine.target}) {
                    let targetRowIndexPath = IndexPath(row: target, section: 0)
                    tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
                    mainTableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
                }
                
            }
        } else if (tableView == self.tableView){
            let row = indexPath.row
            let thisLine = self.model[row]
            let breakPoint = UInt16(thisLine.lineNumber)
            if (z80.breakPoints.contains(breakPoint)){
                while z80.breakPoints.contains(breakPoint){
                    if let index = z80.breakPoints.firstIndex(of: breakPoint) {
                        z80.breakPoints.remove(at: index)
                    }
                }
                
            } else {
                z80.breakPoints.append(breakPoint)
            }
            tableView.reloadData()
        }
    }

}
extension UIImageView {
    func setUpImageView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.magnificationFilter = .nearest
        self.backgroundColor = .black
    }
}
