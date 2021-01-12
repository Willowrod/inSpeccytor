//
//  LineTableViewCell.swift
//  inSpeccytor
//
//  Created by Mike Hall on 10/10/2020.
//

import UIKit

class LineTableViewCell: UITableViewCell {

  
    @IBOutlet weak var lineDescription: UILabel!
    @IBOutlet weak var intValue: UILabel!
    @IBOutlet weak var hexValue: UILabel!
    @IBOutlet weak var lineNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
