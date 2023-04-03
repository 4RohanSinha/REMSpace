//
//  ActivityRecommendationCell.swift
//  REMSpace
//
//  Created by Rohan Sinha on 3/18/23.
//

import UIKit

class ActivityRecommendationCell: UITableViewCell {

    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var activityIsDoneSwitch: UISwitch!
    
    func configure(withActivity activity: Activity) {
        activityName.text = activity.name
        activityIsDoneSwitch.backgroundColor = .systemGray6
        activityIsDoneSwitch.layer.cornerRadius = 16
        activityIsDoneSwitch.isOn = activity.isComplete
    }
}
