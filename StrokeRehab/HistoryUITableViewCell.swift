//
//  HistoryUITableViewCell.swift
//  StrokeRehab
//
//  Created by mobiledev on 23/5/2022.
//

import UIKit

class HistoryUITableViewCell: UITableViewCell {

    @IBOutlet weak var repeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
