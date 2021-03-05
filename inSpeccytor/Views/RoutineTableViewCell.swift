//
//  RoutineTableViewCell.swift
//  inSpeccytor
//
//  Created by Mike Hall on 04/03/2021.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {

    @IBOutlet weak var routine: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
