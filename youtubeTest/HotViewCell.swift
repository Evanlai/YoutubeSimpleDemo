//
//  HotViewCell.swift
//  youtubeTest
//
//  Created by Lai Evan on 9/27/17.
//  Copyright © 2017 Lai Evan. All rights reserved.
//

import UIKit

class HotViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
