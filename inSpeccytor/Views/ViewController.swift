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
    @IBOutlet weak var fpsLabel: UILabel!
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var newByte: UITextField!
    
    @IBOutlet weak var primaryFunction: UISegmentedControl!
    @IBOutlet weak var debuggerView: UIView!
    @IBOutlet weak var registersView: UIView!
    
    @IBOutlet weak var screenHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        setFunctionScreen()
    }
    
    @IBAction func debugStep(_ sender: Any) {
        computer?.shouldStep = true
        computer?.shouldBreak = false
    }
    
    @IBAction func debugPause(_ sender: Any) {
        computer?.shouldForceBreak = true
    }
    
    @IBAction func debugPlay(_ sender: Any) {
        computer?.shouldStep = false
        computer?.shouldBreak = false
        computer?.shouldForceBreak = false
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
        mainTableView.reloadData()
    }
    
    @IBAction func loadSnapShot(_ sender: Any) {
        createFileList()
        snapShotTableView.isHidden = false
    }
    
    override func hideSnapShotTable(){
        snapShotTableView.isHidden = true
    }
    
    
    override func updateRegisters(){
        switch computerModel {
        case .ZXSpectrum_48K, .ZXSpectrum_128K, .ZXSpectrum_128K_Plus2, .ZXSpectrum_128K_Plus3:
            if let speccy = computer as? ZXSpectrum {
                a.text = useHexValues ? speccy.A.hexValue() : speccy.A.stringValue()
                f.text = useHexValues ? Z80.F.hexValue() : Z80.F.stringValue()
                b.text = useHexValues ? speccy.bR().hexValue() : "\(speccy.b())"
                c.text = useHexValues ? speccy.cR().hexValue() : speccy.cR().stringValue()
                d.text = useHexValues ? speccy.dR().hexValue() : speccy.dR().stringValue()
                e.text = useHexValues ? speccy.eR().hexValue() : speccy.eR().stringValue()
                h.text = useHexValues ? speccy.hR().hexValue() : speccy.hR().stringValue()
                l.text = useHexValues ? speccy.lR().hexValue() : speccy.lR().stringValue()
            }
        default:
            print("Model \(computerModel.rawValue) is not currently supported")
        }
        
        fpsLabel.text = "FPS: \(frames / seconds) in \(seconds) seconds"
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
        computer?.writeCodeBytes()
        stopAfterEachOpCode = false
        updatePC()
        print("Disassembly from PC at \(String(pCInDisAssembler, radix: 16))")
        parseLine()
    }
    
    @IBAction func stepFromPC(_ sender: Any) {
        stopAfterEachOpCode = true
        updatePC()
        parseLine()
    }
    
    @IBAction func poke(_ sender: Any) {
        if address.text == "" || newByte.text == "" {
            computer?.ldRam(location: UInt16(0x5821), value: UInt8(0x0b))
            computer?.ldRam(location: UInt16(0x5822), value: UInt8(0x4b))
            computer?.ldRam(location: UInt16(0x5823), value: UInt8(0xcb))
        } else {
        if baseSelector.selectedSegmentIndex == 0 {
            computer?.ldRam(location: UInt16(address.text ?? "0000", radix: 16) ?? 0xffff, value: UInt8(newByte.text ?? "00", radix: 16) ?? 0x00)
        } else {
            computer?.ldRam(location: UInt16(address.text ?? "0") ?? 0xffff, value: UInt8(newByte.text ?? "00") ?? 0x00)
        }
//        address.text = "0000"
//        newByte.text = "00"
        }
    }
    
    override func updateCodeByteModel(model: [CodeByteModel]){
        self.model = model
        tableView.reloadData()
    }
    
    func setFunctionScreen(){
        switch primaryFunction.selectedSegmentIndex {
        case 0:
            screenHeightConstraint.constant = self.view.frame.height * 0.9
            mainTableView.isHidden = true
            tableView.isHidden = true
            debuggerView.isHidden = true
            hexView.isHidden = true
            registersView.isHidden = true
        default:
            screenHeightConstraint.constant = self.view.frame.height * 0.5
            mainTableView.isHidden = false
            tableView.isHidden = false
            debuggerView.isHidden = false
            hexView.isHidden = false
            registersView.isHidden = false
        }
    }
    
    @IBAction func changeFunction(_ sender: Any) {
        setFunctionScreen()
    }
    
    
}


