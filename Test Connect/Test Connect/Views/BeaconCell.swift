//
//  BeaconCell.swift
//  Safe Beacon
//
//  Created by Miriam Haart on 3/17/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit

class BeaconCell: UITableViewCell {

    @IBOutlet weak var beaconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
