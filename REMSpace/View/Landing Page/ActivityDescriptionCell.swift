//
//  ActivityDescriptionCell.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/6/23.
//

import UIKit

class ActivityDescriptionCell: ActivitySummaryCell {

    @IBOutlet weak var activityDescriptionField: UITextView!

    override func configureWithActivity(activity: Activity) {
        super.configureWithActivity(activity: activity)
        activityDescriptionField.text = activity.actDescr
        
    }
}
