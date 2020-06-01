//
//  CustomTableViewCellSecond.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/29.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit

class CustomTableViewCellSecond: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
       for subview in self.contentView.subviews {
           subview.removeFromSuperview()
       }
       
    }
    
}
