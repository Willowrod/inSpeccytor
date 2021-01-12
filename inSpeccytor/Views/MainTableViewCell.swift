//
//  MainTableViewCell.swift
//  inSpeccytor
//
//  Created by Mike Hall on 01/11/2020.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var lineNumber: UILabel!
    @IBOutlet weak var opCode: UILabel!
    @IBOutlet weak var meaning: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
