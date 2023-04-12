//
//  DailySleepDataView.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/11/23.
//

import UIKit

class DailySleepDataView: UIView {
    @IBOutlet weak var sleepScoreIndicator: UIView!
    @IBOutlet weak var sleepScoreTxtField: UITextField!
    
    @IBOutlet weak var remQualityIndicator: UIView!
    @IBOutlet weak var remQualityTxtField: UITextField!
    
    @IBOutlet weak var restfulnessIndicator: UIView!
    @IBOutlet weak var restfulnessTxtField: UITextField!
    
    //MARK: add timing
    @IBOutlet weak var sleepLogsPageCtrl: UIPageControl!
}
