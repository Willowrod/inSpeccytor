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
    
    let textCellIdentifier = "lineCell"
    
    var model: Array<CodeByteModel> = []
    
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
            
            print ("Data: \(contents)")
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
        } else {
            fileName.text = "Failed to create model"
        }
    }
    
    func sortHeaderDataPass(){
        if (model.count > 26){
            
        }
    }
    
    func sortInitialDataPass(){
        
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

