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

    override func viewDidLoad() {
        super.viewDidLoad()
        z80.delegate = self
        screenRender.setUpImageView()

        bootEmulator()
    }
    
    func bootEmulator(){
        loadROM()
     //   loadSnapshot(sna: "actionbiker")
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
            bit = 2
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
                loadZ80(z80: name)
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
        z80.initialiseRegisters(header: snapShot.registers)
        z80.writeRAM(dataModel: snapShot.ramBanks[0], startAddress: 16384)
    }
    
    func loadZ80(z80: String){
//        if let filePath = Bundle.main.path(forResource: sna, ofType: "sna"){
//            print("File found - \(filePath)")
//            if let index = filePath.lastIndex(of: "/"){
//                let name = filePath.substring(from: index)
//                fileName.text = name
//            } else {
//                fileName.text = "Unknown Snapshot"
//                hexView.text = "- - - - - - - -"
//            }
//            let contents = NSData(contentsOfFile: filePath)
//            let data = contents! as Data
//            let dataString = data.hexString
//            expandData(data: dataString)
//            sortHeaderDataPass(data: dataString)
//        } else {
//            fileName.text = "Snapshot failed to load"
//            hexView.text = "- - - - - - - -"
//            print("file not found")
//        }
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
            switch (thisLine.lineType){
            case .CODE:
                cell.lineNumber.text = "++ \(thisLine.line)"
                break
            case .RELATIVE:
                cell.lineNumber.text = "+ \(thisLine.line)"
                break
            case .DATA:
                cell.lineNumber.text = "D \(thisLine.line)"
                break
            case .TEXT:
                cell.lineNumber.text = "T \(thisLine.line)"
                break
            case .GRAPHICS:
                cell.lineNumber.text = "G \(thisLine.line)"
                break
            default:
                cell.lineNumber.text = "\(thisLine.line)"
                break
                
                
            }
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
