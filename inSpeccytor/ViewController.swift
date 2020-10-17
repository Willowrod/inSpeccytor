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
    @IBOutlet weak var programCounter: UITextField!
    
    let pCOffset = 16384 - 27
    
    let textCellIdentifier = "lineCell"
    
    var model: Array<CodeByteModel> = []
    var header: RegisterModel = RegisterModel()
    
    var stopAfterEachOpCode = false;
    
    let z80 = Z80()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            updatePCUI()
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
        let line = "\(header.registerPC)"
        var opCode = z80.opCode(code: getCodeByte().hexValue)
        header.registerPC += 1
        if opCode.isPreCode {
            opCode = z80.opCode(code: "\(opCode.value)\(getCodeByte().hexValue)")
            header.registerPC += 1
        }
        
        if opCode.length == 2 {
            let byte = getCodeByte().intValue
            opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(byte)")
            opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(byte)")
            header.registerPC += 1
        } else if opCode.length == 3 {
            let low = getCodeByte().intValue
            header.registerPC += 1
            let high = getCodeByte().intValue
            
            if (opCode.meaning.contains("$$")){
            let word = (high * 256) + low
            opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(word)")
            opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(word)")
            } else {
                opCode.code = opCode.code.replacingOccurrences(of: "$1", with: "\(low)").replacingOccurrences(of: "$2", with: "\(high)")
                opCode.meaning = opCode.meaning.replacingOccurrences(of: "$1", with: "\(low)").replacingOccurrences(of: "$2", with: "\(high)")
            }
            header.registerPC += 1
        }
        print("\(line): \(opCode.toString())")
        if (opCode.isEndOfRoutine){
            if (stopAfterEachOpCode){
                runLoop = false
                updatePCUI()
            } else {
                print(" ---------------------- ")
            }
        }
            
            if (header.registerPC - pCOffset >= model.count){
                print("End Of File")
                runLoop = false
                header.registerPC -= 1
                updatePCUI()
            }
        }
    }
    
    
    
    
    
    
    
    // Delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! LineTableViewCell

        let row = indexPath.row
        let thisLine = self.model[row]
        cell.lineNumber.text = "\(thisLine.lineNumber)"
        cell.hexValue.text = thisLine.hexValue
        cell.intValue.text = "\(thisLine.intValue)"

        return cell
    }

}

