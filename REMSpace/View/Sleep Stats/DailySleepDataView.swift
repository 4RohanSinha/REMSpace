//
//  DailySleepDataView.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/11/23.
//

import UIKit

class DailySleepDataView: UIView {
    
    @IBOutlet weak var dateTitleLbl: UILabel!
    
    @IBOutlet weak var sleepScoreIndicator: UIView!
    @IBOutlet weak var sleepScoreTxtField: UITextField!
    var sleepScoreProgressView: CircularProgressBarView!
    
    @IBOutlet weak var remQualityIndicator: UIView!
    @IBOutlet weak var remQualityTxtField: UITextField!
    var remQualityProgressView: CircularProgressBarView!
    
    @IBOutlet weak var restfulnessIndicator: UIView!
    @IBOutlet weak var restfulnessTxtField: UITextField!
    var restfulnessProgressView: CircularProgressBarView!
    
    @IBOutlet weak var daysActivitiesTableView: UITableView!
    
    //MARK: add timing
    @IBOutlet weak var sleepLogsPageCtrl: UIPageControl!
    
    var sleepLogs: [SleepLogEntry] = []
    
    var dayActivities: [Activity] = []
    
    var currentSleepLogIdx_: Int?
    
    var updateHandler: ((Int) -> ())?
    
    var dataController: DataController?
    
    var currentSleepLogIdx: Int? {
        get {
            return currentSleepLogIdx_
        } set {
            currentSleepLogIdx_ = newValue
            sleepLogsPageCtrl.currentPage = newValue ?? 0
            updateHandler?(newValue ?? 0)
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        sleepScoreProgressView = CircularProgressBarView(frame: sleepScoreIndicator.frame)
        addSubview(sleepScoreProgressView)
        
        if let remQualityFrame = remQualityIndicator.superview?.convert(remQualityIndicator.frame, to: self.coordinateSpace), let remQualityCtr = remQualityIndicator.superview?.convert(remQualityTxtField.center, to: self.coordinateSpace) {
            remQualityProgressView = CircularProgressBarView(frame: remQualityFrame)
        }
        
        addSubview(remQualityProgressView)
        
        
        if let restfulnessFrame = restfulnessIndicator.superview?.convert(restfulnessIndicator.frame, to: self.coordinateSpace) {
            restfulnessProgressView = CircularProgressBarView(frame: restfulnessFrame)
        }
        
        addSubview(restfulnessProgressView)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(incrementPageCtrl))
        swipeLeftGestureRecognizer.direction = .left
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decrementPageCtrl))
        swipeRightGestureRecognizer.direction = .right
        
        addGestureRecognizer(swipeLeftGestureRecognizer)
        addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    func configure(sleepLogs: [SleepLogEntry], currentSleepLogIdx: Int?, updateHandler: @escaping (Int) -> ()) {
        self.sleepLogs = sleepLogs
        self.sleepLogs.sort { $0.date! < $1.date! }
        sleepLogsPageCtrl.numberOfPages = sleepLogs.count
        self.currentSleepLogIdx = currentSleepLogIdx ?? self.sleepLogs.count - 1
        self.updateHandler = updateHandler
            }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func updateViews() {
        
        daysActivitiesTableView.dataSource = self
        daysActivitiesTableView.delegate = self

        guard let currentSleepLogIdx = currentSleepLogIdx, currentSleepLogIdx < sleepLogs.count else { return }
        let currentSleepLog = sleepLogs[currentSleepLogIdx]
        
        dateTitleLbl.text = formatDate(date: currentSleepLog.date ?? Date())
        
        //sleepLogsPageCtrl.numberOfPages = sleepLogs.count
        //print(sleepLogs.count)
        
        sleepScoreTxtField.text = String(describing: currentSleepLog.sleepScore)
        sleepScoreProgressView.progressValue = Float(currentSleepLog.sleepScore)/100
        
        remQualityTxtField.text = String(describing: currentSleepLog.remSleepQuality)
        remQualityProgressView.progressValue = Float(currentSleepLog.remSleepQuality)/100
        
        restfulnessTxtField.text = String(describing: currentSleepLog.restfulnessScore)
        restfulnessProgressView.progressValue = Float(currentSleepLog.restfulnessScore)/100
        
        daysActivitiesTableView.reloadData()
    }
    
    @IBAction func onPageCtrlShift(_ sender: Any) {
        currentSleepLogIdx = sleepLogsPageCtrl.currentPage
    }
    
    @objc func incrementPageCtrl() {
        if let currentSleepLogIdx = currentSleepLogIdx, currentSleepLogIdx < sleepLogs.count - 1 {
            self.currentSleepLogIdx! += 1
        }
    }
    
    @objc func decrementPageCtrl() {
        if let currentSleepLogIdx = currentSleepLogIdx, currentSleepLogIdx > 0 {
            self.currentSleepLogIdx! -= 1
        }
    }
    
    
}


extension DailySleepDataView: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let currentSleepLogIdx = currentSleepLogIdx,             let currentSleepLogDate = sleepLogs[currentSleepLogIdx].date {
            let activitiesFetchRequest = Activity.fetchRequest()
            activitiesFetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", getStartAndEndDates(date: currentSleepLogDate).0 as CVarArg, getStartAndEndDates(date: currentSleepLogDate).1 as CVarArg)
            
            if let activities = try? dataController?.viewContext.fetch(activitiesFetchRequest) {
                self.dayActivities = activities
                print(self.dayActivities.map { $0.date })
            }
            
        }
        
        print(dayActivities.count)
        return dayActivities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activityRecapCell", for: indexPath) as? PastActivityRecapCell {
            cell.activityRecapName.text = dayActivities[indexPath.row].name
            return cell
            
        }
        
        return UITableViewCell()
    }
}
