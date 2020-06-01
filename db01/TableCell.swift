//
//  TableCell.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/24.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
