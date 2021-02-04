//
//  MainTableViewCell.swift
//  inSpeccytor
//
//  Created by Mike Hall on 01/11/2020.
//

import UIKit

protocol CodeLineDelegate {
    func updateComment(id: Int, comment: String)
    func updateOpCode(id: Int, comment: String)
    func updateByteValue(id: Int, comment: String)
    func updateLineType(id: Int, comment: TypeOfTarget)
    func updateJumpLabel(id: Int, comment: String)
}

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var lineNumber: UILabel!
    @IBOutlet weak var jumpLabel: UITextField!
    @IBOutlet weak var opCode: UITextField!
    @IBOutlet weak var byteContent: UITextField!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var lineNumberWidth: NSLayoutConstraint!
    @IBOutlet weak var jumpLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var byteCountWidth: NSLayoutConstraint!
    @IBOutlet weak var lineTypeButton: UIButton!
    
    var lineType: TypeOfTarget = .CODE
    
    
    var delegate: CodeLineDelegate? = nil
    var id = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDelegate(iD: Int, del: CodeLineDelegate){
        id = iD
        delegate = del
    }
    
    func setLineType(type: TypeOfTarget){
        lineType = type
        updateTypeButton()
    }
    
    func updateTypeButton(){
        print ("Button currently \(lineTypeButton.titleLabel?.text ?? "Unknown")")
        switch lineType{
        case .CODE:
            lineTypeButton.setTitle("🆗", for: .normal)
        case .DATA:
            lineTypeButton.setTitle("🔢", for: .normal)
        case .TEXT:
            lineTypeButton.setTitle("🔠", for: .normal)
        case .GRAPHICS:
            lineTypeButton.setTitle("🎦", for: .normal)
        default:
            lineTypeButton.setTitle("🆗", for: .normal)
        }
        print ("Button now \(lineTypeButton.titleLabel?.text ?? "Unknown")")
    }
    
    @IBAction func lineTypeTapped(_ sender: Any) {
        switch lineType{
        case .CODE:
            setLineType(type: .DATA)
        case .DATA:
            setLineType(type: .TEXT)
        case .TEXT:
            setLineType(type: .GRAPHICS)
        case .GRAPHICS:
            setLineType(type: .CODE)
        default:
            setLineType(type: .CODE)
        }
        delegate?.updateLineType(id: id, comment: lineType)
    }
    
    
    @IBAction func jumpLabelChanged(_ sender: Any) {
        if let commentText = jumpLabel.text {
        delegate?.updateJumpLabel(id: id, comment: commentText)
        }
    }
    
    @IBAction func opCodeChanged(_ sender: Any) {
        if let commentText = opCode.text {
        delegate?.updateOpCode(id: id, comment: commentText)
        }
    }
    
    @IBAction func byteContentChange(_ sender: Any) {
        if let commentText = byteContent.text {
        delegate?.updateByteValue(id: id, comment: commentText)
        }
    }
    
    
    
    @IBAction func updateCodeComment(_ sender: Any) {
        if let commentText = comment.text {
        delegate?.updateComment(id: id, comment: commentText)
        }
    }
    
    
    
    
    
}
