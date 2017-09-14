//
//  PhotoCell.swift
//  rumblr
//
//  Created by Angela Yu on 9/13/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
