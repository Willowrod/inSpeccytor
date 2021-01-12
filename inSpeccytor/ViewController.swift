//
//  ViewController.swift
//  inSpeccytor
//
//  Created by Mike Hall on 10/10/2020.
//

import UIKit

class ViewController: BaseViewController {
    

    @IBOutlet weak var a: UILabel!
    @IBOutlet weak var f: UILabel!
    @IBOutlet weak var b: UILabel!
    @IBOutlet weak var c: UILabel!
    @IBOutlet weak var d: UILabel!
    @IBOutlet weak var e: UILabel!
    @IBOutlet weak var h: UILabel!
    @IBOutlet weak var l: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func debugStep(_ sender: Any) {
        z80.shouldStep = true
        z80.shouldBreak = false
    }
    
    @IBAction func debugPause(_ sender: Any) {
        z80.shouldForceBreak = true
    }
    
    @IBAction func debugPlay(_ sender: Any) {
        z80.shouldStep = false
        z80.shouldBreak = false
        z80.shouldForceBreak = false
    }
    
    @IBAction func debugJump(_ sender: Any) {
        if jumpBox.hasText {
            var jumpTo: Int = 0
            if baseSelector.selectedSegmentIndex == 0 {
                jumpTo = Int(jumpBox.text ?? "5B00", radix: 16) ?? 23296
            } else {
              jumpTo = Int(jumpBox.text ?? "23296") ?? 23296
            }
            updateDebug(line: UInt16(jumpTo))
        }
        jumpBox.resignFirstResponder()
    }
    
    @IBAction func baseChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    override func updateRegisters(){
        a.text = useHexValues ? z80.A.hexValue() : z80.A.stringValue()
        f.text = useHexValues ? Z80.F.hexValue() : Z80.F.stringValue()
        b.text = useHexValues ? z80.bR().hexValue() : "\(z80.b())"
        c.text = useHexValues ? z80.cR().hexValue() : z80.cR().stringValue()
        d.text = useHexValues ? z80.dR().hexValue() : z80.dR().stringValue()
        e.text = useHexValues ? z80.eR().hexValue() : z80.eR().stringValue()
        h.text = useHexValues ? z80.hR().hexValue() : z80.hR().stringValue()
        l.text = useHexValues ? z80.lR().hexValue() : z80.lR().stringValue()
    }
    

    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else {
            return
        }
        
      //  print("Key pressed: \(key.keyCode.rawValue)")
        keyboardInteraction(key: key.keyCode.rawValue, pressed: true)
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else {
            return
        }
        
     //   print("Key released: \(key.keyCode.rawValue)")
        keyboardInteraction(key: key.keyCode.rawValue, pressed: false)
    }
    
    @IBAction func runFromPC(_ sender: Any) {
//        stopAfterEachOpCode = false
//        updatePC()
//        parseLine()
    }
    
    @IBAction func stepFromPC(_ sender: Any) {
//        stopAfterEachOpCode = true
//        updatePC()
//        parseLine()
    }
    
//    func updatePC(){
//        if let pc = programCounter.text, pc.count == 5, let pcInt = Int(pc) {
//            header.registerPC = pcInt
//        }
//    }
//
//    func updatePCUI(){
//        programCounter.text = "\(header.registerPC)"
//        let modelPosition = header.registerPC - pCOffset
//        if (modelPosition < model.count){
//            let targetRowIndexPath = IndexPath(row: modelPosition, section: 0)
//            tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
//        }
//    }
//
//    func updatePCUI(pc: Int){
//        programCounter.text = "\(pc)"
//        let modelPosition = pc - pCOffset
//        if (modelPosition < model.count){
//            let targetRowIndexPath = IndexPath(row: modelPosition, section: 0)
//            //   tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
//        }
//    }
//
//    func getCodeByte() -> CodeByteModel {
//        let modelPosition = header.registerPC
//        if (modelPosition < model.count){
//            return model[modelPosition]
//        } else {
//            return model.first ?? CodeByteModel(withHex: "00", line: modelPosition)
//        }
//    }
//
//    func getCodeByteValue(position: Int) -> Int {
//        let modelPosition = position // - pCOffset
//        if (modelPosition < model.count){
//            return model[modelPosition].intValue
//        }
//        return 0
//    }
//
//    func parseLine(){
//        var runLoop = true
//        while runLoop{
//            let lineAsInt = header.registerPC
//            var opCode = opcodeLookup.opCode(code: getCodeByte().hexValue)
//            header.registerPC += 1
//            if opCode.isPreCode {
//                opCode = opcodeLookup.opCode(code: "\(opCode.value)\(getCodeByte().hexValue)")
//                header.registerPC += 1
//            }
//            if opCode.length == 2 {
//                let byte: UInt8 = UInt8(getCodeByte().intValue)
//                if opCode.code.contains("±"){
//                    opCode.code = opCode.code.replacingOccurrences(of: "±", with: "\(byte)")
//                } else if opCode.code.contains("$$"){
//                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(byte)")
//                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(byte)")
//                    //opCode.code = "###\(opCode.code)"
//                } else if opCode.code.contains("##"){ // Two's compliment
//                    var twos = Int8(bitPattern: ~byte)
//                    if (byte == 127){
//                        twos = -1
//                    } else {
//                        twos -= 1 // Why is this -1 and not 1?
//                    }
//                    let targetLine = header.registerPC - 1 - Int(twos)
//                    opCode.target = targetLine
//                    opCode.code = opCode.code.replacingOccurrences(of: "##", with: "\(targetLine)")
//                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "##", with: "\(twos)")
//                }
//                opCode.meaning = opCode.meaning.replacingOccurrences(of: "±", with: "\(byte)")
//                header.registerPC += 1
//            } else if opCode.length == 3 {
//                let low = getCodeByte().intValue
//                header.registerPC += 1
//                let high = getCodeByte().intValue
//
//                if (opCode.code.contains("$$")){
//                    let word = (high * 256) + low
//                    opCode.target = word
//                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "\(word)")
//                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(word)")
//                } else {
//                    opCode.code = opCode.code.replacingOccurrences(of: "$1", with: "\(low)").replacingOccurrences(of: "$2", with: "\(high)")
//                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$1", with: "\(low)").replacingOccurrences(of: "$2", with: "\(high)")
//                }
//                header.registerPC += 1
//            }
//            opCode.line = lineAsInt
//            opCodes.append(opCode)
//            //            print("\(lineAsInt): \(opCode.toString())")
//            //        if (opCode.isEndOfRoutine){
//            //            if (stopAfterEachOpCode){
//            //                runLoop = false
//            //                updatePCUI()
//            //            } else {
//            //                print(" ---------------------- ")
//            //                mainTableView.reloadData()
//            //            }
//            //        }
//
//            if (header.registerPC >= model.count){
//                //             print("End Of File")
//                runLoop = false
//                header.registerPC -= 1
//                updatePCUI()
//                mainTableView.reloadData()
//                markPositions()
//            }
//        }
//
//    }
//
//    func markPositions(){
//        let tempCodes = opCodes
//        tempCodes.forEach({ opCode in
//            if (opCode.target > 0){
//                if let target = self.opCodes.firstIndex(where: {$0.line == opCode.target}) {
//                    // print("Target: \(target.line) is jump position")
//                    //                    let jumpPos = opCodes[target]
//                    //                    print("Target: \(jumpPos.line) is jump position")
//                    //opCodes[target].isJumpPosition = true
//                    opCodes[target].lineType = opCode.targetType
//                }
//            }
//        })
//        mainTableView.reloadData()
//    }
//
//

    

    
}


