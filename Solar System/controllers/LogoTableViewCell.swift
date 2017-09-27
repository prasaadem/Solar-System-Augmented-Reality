//
//  LogoTableViewCell.swift
//  Solar System
//
//  Created by Aditya Emani on 9/27/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit

class LogoTableViewCell: UITableViewCell {

    @IBOutlet weak var raysImageView: UIImageView!
    @IBOutlet weak var circleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
