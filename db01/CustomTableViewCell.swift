//
//  CustomTableViewCell.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/25.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import RealmSwift

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
//        progressView.isHidden = true
    }
    override func prepareForReuse() {
         super.prepareForReuse()
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        
     }
}
