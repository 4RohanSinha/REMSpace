//
//  PastActivityRecapCell.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/17/23.
//

import UIKit

class PastActivityRecapCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var activityRecapName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5.0
    }

}
