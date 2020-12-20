//
//  ViewController.swift
//  inSpeccytor
//
//  Created by Mike Hall on 10/10/2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var hexView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var programCounter: UITextField!
    @IBOutlet weak var screenRender: UIImageView!
    
    
    @IBOutlet weak var a: UILabel!
    @IBOutlet weak var f: UILabel!
    @IBOutlet weak var b: UILabel!
    @IBOutlet weak var c: UILabel!
    @IBOutlet weak var d: UILabel!
    @IBOutlet weak var e: UILabel!
    @IBOutlet weak var h: UILabel!
    @IBOutlet weak var l: UILabel!
    
    
    
    
    
    
    
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
    
    var useHexValues = true
    
    var bitmap = Bitmap(width: 256, height: 192, color: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImageView()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .common)
        doIt()
        
        z80.testRegisters()
    }
    
    func blitMeAScreen(){
        if (shouldDisplayScreen){
            //     shouldDisplayScreen = false
            bitmap.setAttributes(bytes: z80.ram[22528...23295], flashing: flashOn)
            bitmap.blit(bytes: z80.ram[16384...22527])
            screenRender.image = UIImage(bitmap: bitmap)
            updateRegisters()
        }
    }
    
    func updateRegisters(){
        a.text = useHexValues ? z80.A.hexValue() : z80.A.stringValue()
        f.text = useHexValues ? Z80.F.hexValue() : Z80.F.stringValue()
        b.text = useHexValues ? z80.b().hexValue() : z80.b().stringValue()
        c.text = useHexValues ? z80.c().hexValue() : z80.c().stringValue()
        d.text = useHexValues ? z80.d().hexValue() : z80.d().stringValue()
        e.text = useHexValues ? z80.e().hexValue() : z80.e().stringValue()
        h.text = useHexValues ? z80.h().hexValue() : z80.h().stringValue()
        l.text = useHexValues ? z80.l().hexValue() : z80.l().stringValue()
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        let timestamp = displayLink.timestamp
        let intedTimestamp = Int(timestamp)
        //let partial = timestamp - Double(intedTimestamp)
        if lastFlashChange + 0.32 < timestamp {
            lastFlashChange = timestamp
            flashOn = !flashOn
        }
        if lastcount < intedTimestamp {
            lastcount = intedTimestamp
            seconds += 1
            //  print ("FPS: \(frames / seconds)")
            hexView.text = "FPS: \(frames / seconds) in \(seconds) seconds"
        }
        frames += 1
        
        blitMeAScreen()
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
        if let dataModel = data?.splitToBytes(separator: " "){
            self.model = dataModel
            z80.writeRAM(dataModel: dataModel, ignoreHeader: false)
            
        } else {
            fileName.text = "Failed to create ROM"
        }
    }
    
    func doIt(){
        // Load the snapshot
        
        loadROM()
        
        
        if let filePath = Bundle.main.path(forResource: "aticatac", ofType: "sna"){
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
            
            // print ("Data: \(contents)")
            //hexView.text = dataString
            sortHeaderDataPass(data: dataString)
            expandData(data: dataString)
        } else {
            fileName.text = "Snapshot failed to load"
            hexView.text = "- - - - - - - -"
            print("file not found")
        }
    }
    
    func expandData(data: String?){
        if let dataModel = data?.splitToBytes(separator: " ", startFrom: 16384){
            //        hexView.text = "\(dataModel)"
            print ("Data model size = \(dataModel.count)")
            print ("Model size = \(self.model.count)")
            print ("New Model size = \(self.model.count)")
            z80.writeRAM(dataModel: Array<CodeByteModel>(dataModel[27...]), ignoreHeader: true)
            self.model.append(contentsOf: Array<CodeByteModel>(dataModel[27...]))    // = dataModel
            tableView.reloadData()
            shouldDisplayScreen = true
        } else {
            fileName.text = "Failed to create model"
        }
    }
    
    func sortHeaderDataPass(data: String?){
        if let dataModel = data?.splitToHeader(separator: " "){
            header = RegisterModel.init(header: dataModel)
            z80.initialiseRegisters(header: header)
            updatePCUI(pc: 0) //23296
        }
    }
    
    func sortInitialDataPass(){
        
    }
    
    @IBAction func runFromPC(_ sender: Any) {
        stopAfterEachOpCode = false
        updatePC()
        parseLine()
    }
    
    
    @IBAction func stepFromPC(_ sender: Any) {
        stopAfterEachOpCode = true
        updatePC()
        parseLine()
    }
    
    func updatePC(){
        if let pc = programCounter.text, pc.count == 5, let pcInt = Int(pc) {
            header.registerPC = pcInt
        }
    }
    
    func updatePCUI(){
        programCounter.text = "\(header.registerPC)"
        let modelPosition = header.registerPC - pCOffset
        if (modelPosition < model.count){
            let targetRowIndexPath = IndexPath(row: modelPosition, section: 0)
            tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
        }
    }
    
    func updatePCUI(pc: Int){
        programCounter.text = "\(pc)"
        let modelPosition = pc - pCOffset
        if (modelPosition < model.count){
            let targetRowIndexPath = IndexPath(row: modelPosition, section: 0)
         //   tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
        }
    }
    
    func getCodeByte() -> CodeByteModel {
        let modelPosition = header.registerPC // - pCOffset
        
         print("fetching line \(header.registerPC) from model size \(model.count) in position \(modelPosition)")
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
            let lineAsInt = header.registerPC
            var opCode = opcodeLookup.opCode(code: getCodeByte().hexValue)
            header.registerPC += 1
            if opCode.isPreCode {
                opCode = opcodeLookup.opCode(code: "\(opCode.value)\(getCodeByte().hexValue)")
                header.registerPC += 1
            }
            if opCode.length == 2 {
                let byte: UInt8 = UInt8(getCodeByte().intValue)
                if opCode.code.contains("±"){
                    opCode.code = opCode.code.replacingOccurrences(of: "±", with: "\(byte)")
                } else if opCode.code.contains("$$"){
                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(byte)")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(byte)")
                    //opCode.code = "###\(opCode.code)"
                } else if opCode.code.contains("##"){ // Two's compliment
                    var twos = Int8(bitPattern: ~byte)
                    if (byte == 127){
                        twos = -1
                    } else {
                        twos -= 1 // Why is this -1 and not 1?
                    }
                    let targetLine = header.registerPC - 1 - Int(twos)
                    opCode.target = targetLine
                    opCode.code = opCode.code.replacingOccurrences(of: "##", with: "\(targetLine)")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "##", with: "\(twos)")
                }
                opCode.meaning = opCode.meaning.replacingOccurrences(of: "±", with: "\(byte)")
                header.registerPC += 1
            } else if opCode.length == 3 {
                let low = getCodeByte().intValue
                header.registerPC += 1
                let high = getCodeByte().intValue
                
                if (opCode.code.contains("$$")){
                    let word = (high * 256) + low
                    opCode.target = word
                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(word)")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(word)")
                } else {
                    opCode.code = opCode.code.replacingOccurrences(of: "$1", with: "\(low)").replacingOccurrences(of: "$2", with: "\(high)")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$1", with: "\(low)").replacingOccurrences(of: "$2", with: "\(high)")
                }
                header.registerPC += 1
            }
            opCode.line = lineAsInt
            opCodes.append(opCode)
            print("\(lineAsInt): \(opCode.toString())")
            //        if (opCode.isEndOfRoutine){
            //            if (stopAfterEachOpCode){
            //                runLoop = false
            //                updatePCUI()
            //            } else {
            //                print(" ---------------------- ")
            //                mainTableView.reloadData()
            //            }
            //        }
            
            if (header.registerPC >= model.count){
                print("End Of File")
                runLoop = false
                header.registerPC -= 1
                updatePCUI()
                mainTableView.reloadData()
                markPositions()
            }
        }
        
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
            cell.lineNumber.text = "\(thisLine.lineNumber)"
            cell.hexValue.text = thisLine.hexValue
            cell.intValue.text = "\(thisLine.intValue)"
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
        }
    }
    
}

extension ViewController {
    func setUpImageView() {
        screenRender.translatesAutoresizingMaskIntoConstraints = false
        screenRender.layer.magnificationFilter = .nearest
        screenRender.backgroundColor = .black
    }
}

