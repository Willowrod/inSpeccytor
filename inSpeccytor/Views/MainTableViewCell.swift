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
    
    @IBAction func updateCodeComment(_ sender: Any) {
        if let commentText = comment.text {
        delegate?.updateComment(id: id, comment: commentText)
        }
    }
}
