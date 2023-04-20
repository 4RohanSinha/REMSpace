//
//  SleepStatsViewController.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/11/23.
//

import UIKit
import SwiftUI

class SleepStatsViewController: CoreDataStackViewController {
    @IBOutlet weak var graphView: UIView!
    var graphVC: UIHostingController<SleepLogGraph>!
    
    @IBOutlet weak var sleepDataByDayView: DailySleepDataView!
        
    var sleepLogs: [SleepLogEntry] = []
    var currentSleepLogIndex: Int?
    
    var graphStartIdx: Int?
    var graphEndIdx: Int?
    
    
    var sleepLogsSubset: [SleepLogEntry] {
        return Array(sleepLogs[graphStartIdx!...graphEndIdx!])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphEndIdx = currentSleepLogIndex ?? (sleepLogs.count - 1)
        
        if let currentIdx = currentSleepLogIndex, currentIdx >= 10 {
            graphStartIdx = currentIdx - 9
        } else {
            currentSleepLogIndex = graphEndIdx
            graphStartIdx = graphEndIdx! - 9
        }

        
        graphVC = UIHostingController(rootView: SleepLogGraph(sleepLogs: sleepLogsSubset, currentSleepLogIdx: currentSleepLogIndex! - graphStartIdx!, onLogTap: updatePageView(sleepLogIdx:)))
        addChild(graphVC)
        
        graphVC.view.frame = graphView.frame
        graphView.addSubview(graphVC.view)
        graphVC.didMove(toParent: self)
        
        sleepDataByDayView.dataController = dataController
        sleepDataByDayView.configure(sleepLogs: sleepLogs, currentSleepLogIdx: currentSleepLogIndex, updateHandler: reload(sleepLogIdx:))
        sleepDataByDayView.updateViews()
    }
    
    func updatePageView(sleepLogIdx: Int) {
        currentSleepLogIndex = sleepLogIdx
        sleepDataByDayView.currentSleepLogIdx = sleepLogIdx + self.graphStartIdx!
    }
    
    
    func reload(sleepLogIdx: Int) {
        currentSleepLogIndex = sleepLogIdx
        
        graphVC.view.removeFromSuperview()
        graphVC.removeFromParent()
        
        if (sleepLogIdx < graphStartIdx!) {
            graphEndIdx = sleepLogIdx
            currentSleepLogIndex = graphEndIdx!
            graphStartIdx = sleepLogIdx - 9
            
        }
        
        if (sleepLogIdx > graphEndIdx!) {
            graphStartIdx = sleepLogIdx
            currentSleepLogIndex = graphStartIdx!
            graphEndIdx = sleepLogIdx + 9
        }
        
        if (graphStartIdx! < 0) {
            graphStartIdx = 0
        }
        
        if (graphEndIdx! > sleepLogs.count - 1) {
            graphEndIdx = sleepLogs.count - 1
        }
        
        graphVC.rootView = SleepLogGraph(sleepLogs: sleepLogsSubset, currentSleepLogIdx: sleepLogIdx - graphStartIdx!, onLogTap: updatePageView(sleepLogIdx:))
        addChild(graphVC)
        
        graphVC.view.frame = graphView.frame
        graphView.addSubview(graphVC.view)
        graphVC.didMove(toParent: self)
        
        
    }
}
