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

    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var newByte: UITextField!
    
    
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
        mainTableView.reloadData()
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
            z80.ldRam(location: UInt16(0x5821), value: UInt8(0x0b))
            z80.ldRam(location: UInt16(0x5822), value: UInt8(0x4b))
            z80.ldRam(location: UInt16(0x5823), value: UInt8(0xcb))
        } else {
        if baseSelector.selectedSegmentIndex == 0 {
            z80.ldRam(location: UInt16(address.text ?? "0000", radix: 16) ?? 0xffff, value: UInt8(newByte.text ?? "00", radix: 16) ?? 0x00)
        } else {
            z80.ldRam(location: UInt16(address.text ?? "0") ?? 0xffff, value: UInt8(newByte.text ?? "00") ?? 0x00)
        }
//        address.text = "0000"
//        newByte.text = "00"
        }
    }
    
//
//

    

    
}


