//
//  SleepStatsUserControl.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/6/23.
//

import UIKit
import CoreData

class SleepStatsUserControl: UIView {
    var circleProgressView: CircularProgressBarView!
    @IBOutlet weak var progressScoreLbl: UILabel!
    @IBOutlet weak var circleLocation: UIView!
    
    @IBOutlet weak var sleepStatsTitleLbl: UILabel!
    @IBOutlet weak var sleepDatePicker: UIDatePicker!
    
    var dataController: DataController?
    var sleepLogsFetchedResultsController: NSFetchedResultsController<SleepLogEntry>?
    var currentSleepLogIdxPath: IndexPath?
    var vc: LandingPageVC?
    
    var currentSleepScore: Int {
        set {
            circleProgressView.progressValue = Float(newValue)/100
            progressScoreLbl.text = String(describing: newValue)
        } get {
            return Int(circleProgressView.progressValue*100)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleProgressView = CircularProgressBarView(frame: circleLocation.frame)
        addSubview(circleProgressView)
        
        
    }
    
    func initializeFRC() {
        guard let dataController = dataController else { return }
        let sleepLogFetchRequest: NSFetchRequest<SleepLogEntry> = SleepLogEntry.fetchRequest()
        sleepLogFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        sleepLogsFetchedResultsController = NSFetchedResultsController(fetchRequest: sleepLogFetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try sleepLogsFetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        if let sleepLogs = sleepLogsFetchedResultsController?.fetchedObjects, sleepLogs.count > 0 {
            sleepDatePicker.date = sleepLogs.last?.date ?? Date()
        }
    }
    
    deinit {
        sleepLogsFetchedResultsController = nil
    }
    
    func getStartAndEndDates(date: Date) -> (Date, Date) {
        var startComponents = Calendar.current.dateComponents(Set([.year, .month, .day]), from: date)
        var endComponents = Calendar.current.dateComponents(Set([.year, .month, .day]), from: date)
        
        startComponents.hour = 0
        startComponents.minute = 0
        startComponents.second = 0
        
        endComponents.hour = 23
        endComponents.minute = 59
        endComponents.second = 59
        
        return (Calendar.current.date(from: startComponents)!, Calendar.current.date(from: endComponents)!)
    }
    
    func updateView() {
        if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {
            circleProgressView.isHidden = false
            sleepStatsTitleLbl.text = "Sleep Stats"
            sleepDatePicker.isHidden = false
            
            if (sleepDatePicker.date >= getStartAndEndDates(date: Date()).0 && sleepDatePicker.date <= getStartAndEndDates(date: Date()).1) {
                sleepDatePicker.date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            }
            
            let dateRange = getStartAndEndDates(date: sleepDatePicker.date)


            sleepLogsFetchedResultsController?.fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", dateRange.0 as CVarArg, dateRange.1 as CVarArg)
            try? sleepLogsFetchedResultsController?.performFetch()
            
            let filteredObjects = sleepLogsFetchedResultsController?.sections?[0].objects as? [SleepLogEntry]
            
            if let filteredObjects = filteredObjects, filteredObjects.count > 0 {
                circleProgressView.isHidden = false
                currentSleepScore = Int(filteredObjects[0].sleepScore)
            } else {
                progressScoreLbl.text = "-"
                circleProgressView.isHidden = true
            }
        } else {
            progressScoreLbl.text = ""
            circleProgressView.isHidden = true
            sleepStatsTitleLbl.text = "Sign in above to view stats"
            sleepDatePicker.isHidden = true
        }
    }
    
    @IBAction func onDatePickerChange(_ sender: Any) {
        updateView()
        vc?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
