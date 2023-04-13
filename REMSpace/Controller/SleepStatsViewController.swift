//
//  SleepStatsViewController.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/11/23.
//

import UIKit
import SwiftUI

class SleepStatsViewController: UIViewController {
    @IBOutlet weak var graphView: UIView!
    var graphVC: UIHostingController<SleepLogGraph>!
    
    @IBOutlet weak var sleepDataByDayView: DailySleepDataView!
    
    var sleepLogs: [SleepLogEntry] = []
    var currentSleepLogIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphVC = UIHostingController(rootView: SleepLogGraph(sleepLogs: sleepLogs, currentSleepLogIdx: currentSleepLogIndex))
        addChild(graphVC)
        
        graphVC.view.frame = graphView.frame
        graphView.addSubview(graphVC.view)
        graphVC.didMove(toParent: self)
        
        sleepDataByDayView.configure(sleepLogs: sleepLogs, currentSleepLogIdx: currentSleepLogIndex, updateHandler: reload(sleepLogIdx:))
        sleepDataByDayView.updateViews()
    }
    
    func reload(sleepLogIdx: Int) {
        currentSleepLogIndex = sleepLogIdx
        graphVC.view.removeFromSuperview()
        graphVC.removeFromParent()
        
        graphVC.rootView = SleepLogGraph(sleepLogs: sleepLogs, currentSleepLogIdx: currentSleepLogIndex)
        addChild(graphVC)
        
        graphVC.view.frame = graphView.frame
        graphView.addSubview(graphVC.view)
        graphVC.didMove(toParent: self)
        
    }
}
