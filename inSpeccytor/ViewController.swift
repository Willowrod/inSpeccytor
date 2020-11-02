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
    
    let pCOffset = 16384 - 27
    
    let lineCellIdentifier = "lineCell"
    let mainCellIdentifier = "codeCell"
    
    var model: Array<CodeByteModel> = []
    var opCodes: Array<OpCode> = []
    var header: RegisterModel = RegisterModel()
    
    var stopAfterEachOpCode = false;
    
    let z80 = Z80()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        doIt()
    }

    
    func doIt(){
        // Load the snapshot
        if let filePath = Bundle.main.path(forResource: "actionbiker", ofType: "sna"){
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
            hexView.text = dataString
            expandData(data: dataString)
        } else {
            fileName.text = "Snapshot failed to load"
            hexView.text = "- - - - - - - -"
            print("file not found")
        }
    }
    
    func expandData(data: String?){
        if let dataModel = data?.splitToBytes(separator: " "){
//        hexView.text = "\(dataModel)"
            self.model = dataModel
            tableView.reloadData()
            sortHeaderDataPass()
        } else {
            fileName.text = "Failed to create model"
        }
    }
    
    func sortHeaderDataPass(){
        if (model.count > 26){
            header = RegisterModel.init(header: model)
            //updatePCUI()
            updatePCUI(pc: 23296)
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
        tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
        }
    }
    
    func getCodeByte() -> CodeByteModel {
        let modelPosition = header.registerPC - pCOffset
        
       // print("fetching line \(header.registerPC) from model size \(model.count) in position \(modelPosition)")
        if (modelPosition < model.count){
        return model[modelPosition]
        } else {
            return model.first ?? CodeByteModel(withHex: "00", line: modelPosition)
        }
    }
    
    func parseLine(){
        var runLoop = true
        while runLoop{
        let lineAsInt = header.registerPC
        var opCode = z80.opCode(code: getCodeByte().hexValue)
        header.registerPC += 1
        if opCode.isPreCode {
            opCode = z80.opCode(code: "\(opCode.value)\(getCodeByte().hexValue)")
            header.registerPC += 1
        }
        if opCode.length == 2 {
            let byte: UInt8 = UInt8(getCodeByte().intValue)
            if opCode.code.contains("±"){
            opCode.code = opCode.code.replacingOccurrences(of: "±", with: "\(byte)")
            } else if opCode.code.contains("$$"){
                opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(byte)")
                opCode.code = "###\(opCode.code)"
                } else if opCode.code.contains("##"){ // Two's compliment
                var twos = Int8(bitPattern: ~byte)
                twos -= 1 // Why is this -1 and not 1?
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
            
            if (header.registerPC - pCOffset >= model.count){
                print("End Of File")
                runLoop = false
                header.registerPC -= 1
                updatePCUI()
                mainTableView.reloadData()
            }
        }
        
    }
    
    func markPositions(){
        let tempCodes = opCodes
        tempCodes.forEach({ opCode in
            if (opCode.target > 0 && opCode.targetType == .CODE){
                if let target = self.opCodes.firstIndex(where: {$0.line == opCode.target}) {     
                    //target.isJumpPosition = true
                }
            
            }
        })

        
        
        
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
            cell.lineNumber.text = "\(thisLine.line)"
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

