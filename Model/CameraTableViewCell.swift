//
//  CameraTableViewCell.swift
//  ONVIF-LiveFeed
//
//  Created by Jeel Shah on 29/05/18.
//  Copyright © 2018 Jeel Shah. All rights reserved.
//

import UIKit

class CameraTableViewCell: UITableViewCell {
    
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var cameraNameLabel: UILabel!
    
    @IBOutlet weak var cameraIpAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
