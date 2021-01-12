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

    override func viewDidLoad() {
        super.viewDidLoad()
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
extension BaseViewController {
    func setUpImageView() {
        screenRender.translatesAutoresizingMaskIntoConstraints = false
        screenRender.layer.magnificationFilter = .nearest
        screenRender.backgroundColor = .black
    }
}
