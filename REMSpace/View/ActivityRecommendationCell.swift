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
    @IBOutlet weak var activityDescr: UITextView!
    
    func configure(withActivity activity: Activity) {
        activityName.text = activity.name
        activityIsDoneSwitch.isOn = activity.isComplete
    }
}
