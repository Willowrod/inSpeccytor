//
//  IOSViewController.swift
//  inSpeccytor
//
//  Created by Mike Hall on 11/01/2021.
//

import UIKit

class IOSViewController: BaseViewController{
    
    
    @IBOutlet weak var fileTable: UITableView!
    
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var joystickView: UIView!
    
    @IBOutlet weak var keyboardToggle: UIButton!
    @IBOutlet weak var joystickToggle: UIButton!
    
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var snapshotButton: UIButton!
    
    @IBOutlet weak var fileViewConstant: NSLayoutConstraint!
    
    @IBOutlet weak var joystickHeight: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardBottomConstant: NSLayoutConstraint!
    var kbAspectConstant: NSLayoutConstraint? = nil
    var filez: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fileTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        keyboardInteraction(key: sender.tag, pressed: true)
    }
    
    @IBAction func keyReleased(_ sender: UIButton) {
        keyboardInteraction(key: sender.tag, pressed: false)
    }
    
    @IBAction func toggleKeyboard(_ sender: Any) {
        fileViewConstant.constant = 0.0
        if keyboardBottomConstant.constant > 0{
            keyboardBottomConstant.constant = -keyboardView.frame.height
        } else {
            keyboardBottomConstant.constant = 50.0
        }
    }
    
    func changeConstant(oldConstraint: NSLayoutConstraint, newConstraint: NSLayoutConstraint){
        keyboardView.removeConstraint(oldConstraint)
        keyboardView.addConstraint(newConstraint)
        keyboardView.layoutIfNeeded()
    }
    
    @IBAction func toggleJoystick(_ sender: Any) {
        fileViewConstant.constant = 0.0
        if joystickHeight.constant > 0{
            joystickHeight.constant = 0.0
        } else {
            joystickHeight.constant = 160.0
        }
    }
    
    @IBAction func offerSnapshots(_ sender: Any) {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        filez.removeAll()
        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found: \(item)")
                if item.contains(".sna") || item.contains(".z80"){
                    print("Adding: \(item)")
                    filez.append(item)
                }
            }
            fileTable.reloadData()
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    keyboardBottomConstant.constant = -keyboardView.frame.height
    joystickHeight.constant = 0.0
        fileViewConstant.constant = 300
    }
    
    @IBAction func offerMedia(_ sender: Any) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.fileTable){
            return self.filez.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if (tableView == fileTable){
            let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
            cell.textLabel?.text = filez[row]
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == fileTable){
            let row = indexPath.row
            let thisFile = self.filez[row]
            load(file: thisFile)
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }

    
    
}



