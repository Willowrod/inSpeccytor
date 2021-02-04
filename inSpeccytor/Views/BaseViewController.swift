//
//  BaseViewController.swift
//  inSpeccytor
//
//  Created by Mike Hall on 12/01/2021.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CPUDelegate, CodeLineDelegate {
    @IBOutlet weak var screenRender: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var hexView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var programCounter: UITextField!
    @IBOutlet weak var jumpBox: UITextField!
    @IBOutlet weak var baseSelector: UISegmentedControl!
    
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var snapShotTableView: UITableView!
    
    
    let pCOffset = 16384 - 27
    let lineCellIdentifier = "lineCell"
    let mainCellIdentifier = "codeCell"
    var model: [CodeByteModel] = []
    var opCodes: [OpCode] = []
    var stopAfterEachOpCode = false
    var shouldDisplayScreen = false
    let borderX = 0 //32
    let borderY = 0 //24
    var computer: CPU? = nil
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
    var snapShots: [String] = []
    
    var assembler = Z80Assembler()
    
    var computerModel: ComputerModel = .ZXSpectrum_128K//  .ZXSpectrum_48K  //

    override func viewDidLoad() {
        super.viewDidLoad()
        screenRender.setUpImageView()
//        updateBorder(colour: Color.red)
        self.snapShotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "snapshotcell")
        self.snapShotTableView.isHidden = true
        bootEmulator()
    }
    
    func bootEmulator(){
        switch computerModel {
        case .ZXSpectrum_48K:
            computer = ZXSpectrum48K()
        case .ZXSpectrum_128K:
            computer = ZXSpectrum128K()
        default:
            print("Model \(computerModel.rawValue) is not currently supported")
        }
        computer?.delegate = self
        computer?.writeCodeBytes()
        startProcessor()
    }
    
    func startProcessor(){
        DispatchQueue.background(background: {
            self.computer?.process()
        }, completion:{
            // when background job finished, do something in main thread
        })
    }
    
    func keyboardInteraction(key: Int, pressed: Bool){
        
            switch computerModel {
            case .ZXSpectrum_48K, .ZXSpectrum_128K, .ZXSpectrum_128K_Plus2, .ZXSpectrum_128K_Plus3:
                if let speccy = computer as? ZXSpectrum {
                    speccy.keyboardInteraction(key: key, pressed: pressed)
                }
            default:
                print("Model \(computerModel.rawValue) is not currently supported")
            }
    }
    
    func joystickInteraction(key: Int, pressed: Bool){
        switch computerModel {
        case .ZXSpectrum_48K, .ZXSpectrum_128K, .ZXSpectrum_128K_Plus2, .ZXSpectrum_128K_Plus3:
            if let speccy = computer as? ZXSpectrum {
                speccy.joystickInteraction(key: key, pressed: pressed)
            }
        default:
            print("Model \(computerModel.rawValue) is not currently supported")
        }
        
        
    }
    
  
    
  
    
    func updateFPS(){
        let timestamp = Date.init().timeIntervalSince1970
        if timestamp > lastSecond + 1 {
            lastSecond = timestamp
            seconds += 1
            //hexView.text = "FPS: \(frames / seconds) in \(seconds) seconds"
        }
        frames += 1
    }
    
    // Disassembler
    
    func updatePC(){
        if let pc = programCounter.text, pc.count == 5, let pcUint = Int(pc) {
            pCInDisAssembler = pcUint
        } else {
            
            switch computerModel {
            case .ZXSpectrum_48K, .ZXSpectrum_128K, .ZXSpectrum_128K_Plus2, .ZXSpectrum_128K_Plus3:
                if let speccy = computer as? ZXSpectrum {
                    pCInDisAssembler = Int(speccy.header.registerPC)
                }
            default:
                print("Model \(computerModel.rawValue) is not currently supported")
            }
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
//            if pCInDisAssembler == 0xD858 {
//                print ("Debug here!")
//            }
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
                    opCode.code = opCode.code.replacingOccurrences(of: "±", with: "\(UInt8(byte).hex().padded(size: 2))")
                } else if opCode.code.contains("$$"){
                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(UInt8(byte).hex().padded(size: 2))")
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
                    opCode.code = opCode.code.replacingOccurrences(of: "##", with: "\(UInt16(opCode.target).hex().padded(size: 4))")
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
                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(UInt16(word).hex().padded(size: 4))")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(UInt16(word).hex().padded(size: 4))")
                } else {
                    opCode.code = opCode.code.replacingOccurrences(of: "$1", with: "\(UInt8(low).hex().padded(size: 2))").replacingOccurrences(of: "$2", with: "\(UInt8(high).hex().padded(size: 2))")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$1", with: "\(UInt8(low).hex().padded(size: 2))").replacingOccurrences(of: "$2", with: "\(UInt8(high).hex().padded(size: 2))")
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
            
                if opCode.value.uppercased() == "EF" && computer?.usingRom() == .ZXSpectrum_48K {
                    isCalc = true
                }
            
                        print("\(UInt16(lineAsInt).hex()): \(opCode.toString())")
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
            } else
//            if nextEP < 0x4000 {
//
//                } else
            if !alreadyAdded.contains(nextEP){
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
    
    // Code Line Delegate
    
    func updateComment(id: Int, comment: String) {
        if id < opCodes.count{
        opCodes[id].meaning = comment
        }
    }
    
    func updateOpCode(id: Int, comment: String) {
        if id < opCodes.count{
      //  opCodes[id].meaning = comment
        }
    }
    
    func updateByteValue(id: Int, comment: String) {
        if id < opCodes.count{
      //  opCodes[id].meaning = comment
        }
    }
    
    // CPU Delegate
    
    func updateCodeByteModel(model: [CodeByteModel]){
    }
    
    func updateTitle(title: String){
        fileName.text = title
    }
    
    func updateBorder(colour: Color){
        border.backgroundColor = colour.toUIColor()
    }
    
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
    
    func hideSnapShotTable(){
        
    }
    
    func createFileList(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        snapShots.removeAll()
        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found: \(item)")
                if item.contains(".sna") || item.contains(".z80") || item.contains(".zip"){
                    print("Adding: \(item)")
                    snapShots.append(item)
                }
            }
            snapShots.sort()
            snapShotTableView.reloadData()
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    // Tables
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.snapShotTableView){
            return self.snapShots.count
        }
        if (tableView == mainTableView){
            return self.opCodes.count
        }
        return self.model.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if (tableView == self.snapShotTableView){
            let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "snapshotcell") as UITableViewCell?)!
            cell.textLabel?.text = snapShots[row]
            return cell
        }
        if (tableView == mainTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: mainCellIdentifier, for: indexPath) as! MainTableViewCell
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
            if let breakPoints = computer?.breakPoints, breakPoints.contains(breakPoint){
                cell.backgroundColor = UIColor.yellow
            } else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == snapShotTableView){
            let row = indexPath.row
            let thisFile = self.snapShots[row]
            computer?.load(file: thisFile)
            hideSnapShotTable()
        } else if (tableView == mainTableView){
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
            if let breakPoints = computer?.breakPoints{
            if breakPoints.contains(breakPoint){
                while breakPoints.contains(breakPoint){
                    if let index = breakPoints.firstIndex(of: breakPoint) {
                        computer!.breakPoints.remove(at: index)
                    }
                }
                
            } else {
                computer!.breakPoints.append(breakPoint)
            }
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
