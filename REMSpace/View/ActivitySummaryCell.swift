//
//  ActivityDetailCell.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/6/23.
//

import UIKit

class ActivitySummaryCell: UITableViewCell {

    @IBOutlet weak var activityNameLbl: UILabel!
    @IBOutlet weak var activityComplete: Checkbox!

    func configureWithActivity(activity: Activity) {
        activityNameLbl.text = activity.name
        activityComplete.isOn = activity.isComplete
    }
}
