//
//  LandingPageVC.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/6/23.
//

import UIKit
import CoreData
import AVFoundation

class LandingPageVC: CoreDataStackViewController {
    
    @IBOutlet weak var userAcctCtrlView: UserAccountControlView!
    
    @IBOutlet weak var sleepStatsCtrlView: SleepStatsUserControl!
    
    @IBOutlet weak var activitiesTableView: MinMaxTableView!
    
    @IBOutlet weak var loadingSleepStatsIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var currentStatsDate: UIDatePicker!
    
    var activitiesFetchedResultsController: NSFetchedResultsController<Activity>?
    
    var isLoadingSleepData: Bool = false
    
    func configureFetchedResultsController() {
        guard let dataController = dataController else { return }

        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let dateRange = ActivityDateConverter.getStartAndEndDates(date: Date())
        
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", dateRange.0 as CVarArg, dateRange.1 as CVarArg)
        
        activitiesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        activitiesFetchedResultsController?.delegate = self
        
        
        do {
            try activitiesFetchedResultsController?.performFetch()
        } catch {
            print("Error fetching activities")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVSpeechSynthesisVoice.speechVoices()
        
        let usrAcctCtrlTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(logInScreen))
        userAcctCtrlView.addGestureRecognizer(usrAcctCtrlTapRecognizer)
        userAcctCtrlView.reloadViews = updateViews
        
        let sleepStatsCtrlTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sleepStatsScreen))
        sleepStatsCtrlView.addGestureRecognizer(sleepStatsCtrlTapRecognizer)
        
        sleepStatsCtrlView.dataController = dataController
        sleepStatsCtrlView.vc = self
        sleepStatsCtrlView.initializeFRC()
        
        activitiesTableView.dataSource = self
        activitiesTableView.delegate = self
        activitiesTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFetchedResultsController()
        updateViews()
        self.loadingSleepStatsIndicator.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activitiesFetchedResultsController?.delegate = nil
        activitiesFetchedResultsController = nil
    }
    
    @objc func logInScreen() {
        if (!UserDefaults.standard.bool(forKey: "isLoggedIn")) {
            self.loadingSleepStatsIndicator.isHidden = false
            self.loadingSleepStatsIndicator.startAnimating()
            UIApplication.shared.open(OuraClient.Endpoints.loginOauth.url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func sleepStatsScreen() {
        let sleepLogFetchRequest = SleepLogEntry.fetchRequest()
        if let sleepLogs = try? dataController?.viewContext.fetch(sleepLogFetchRequest), UserDefaults.standard.bool(forKey: "isLoggedIn") && !isLoadingSleepData {
            performSegue(withIdentifier: "viewSleepStats", sender: sleepLogs)
        }
    }
    
    @IBAction func onLoginViewBtnTap(_ sender: Any) {
        logInScreen()
    }
    
    func onPersonalInfoComplete(response: OuraPersonalInfoResponse?, error: Error?) {
        if let response = response {
            UserDefaults.standard.set(response.email, forKey: "emailAddr")
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    func onSleepDataComplete(response: OuraSleepResponse?, error: Error?) {
        if let sleepLogsData = response?.data, let dataController = dataController {
            DispatchQueue.main.async {
                
                dataController.viewContext.perform {
                    for sleepLogData in sleepLogsData {
                        let date = ActivityDateConverter.getDateFromString(string: sleepLogData.day)
                        
                        let entry = SleepLogEntry(context: dataController.viewContext)
                        entry.date = date
                        entry.sleepScore = Int16(sleepLogData.score)
                        entry.remSleepQuality = Int16(sleepLogData.contributors.rem_sleep)
                        entry.restfulnessScore = Int16(sleepLogData.contributors.restfulness)
                        
                        try? dataController.viewContext.save()
                    }
                    
                    self.updateViews()
                    
                    self.isLoadingSleepData = false
                    self.loadingSleepStatsIndicator.isHidden = true
                    self.loadingSleepStatsIndicator.stopAnimating()
                }
                
            }
        }
    }
    
    func updateViews() {
        userAcctCtrlView.configure()
        sleepStatsCtrlView.updateView()
        
        if (!UserDefaults.standard.bool(forKey: "isLoggedIn")) {
            let sleepLogFetchRequest = SleepLogEntry.fetchRequest()
            if let sleepLogs = try? dataController?.viewContext.fetch(sleepLogFetchRequest) {
                
                for sleepLog in sleepLogs {
                    dataController?.viewContext.delete(sleepLog)
                }
                
                try? dataController?.viewContext.save()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sleepStatsVC = segue.destination as? SleepStatsViewController, segue.identifier == "viewSleepStats" {
            sleepStatsVC.dataController = dataController
            sleepStatsVC.sleepLogs = sender as? [SleepLogEntry] ?? []
            sleepStatsVC.currentSleepLogIndex = (sleepStatsVC.sleepLogs.sorted {$0.date! < $1.date!}).firstIndex { $0.date! >= ActivityDateConverter.getStartAndEndDates(date: currentStatsDate.date).0 && $0.date! <= ActivityDateConverter.getStartAndEndDates(date: currentStatsDate.date).1 }
            

        }
    }
    
}

extension LandingPageVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objCount = activitiesFetchedResultsController?.sections?[section].numberOfObjects

        if (objCount == 0) {
            ActivityRecommender.updateRecommendations()
        }
        
        return activitiesFetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? MinMaxTableView else { return UITableViewCell() }
        
        let checkboxTapClosure: ((Activity, ActivitySummaryCell) -> ()) = { activity, cell in
            activity.isComplete = cell.activityComplete.isOn
            try? self.dataController?.viewContext.save()
        }
        
        if indexPath == tableView.maximizedRow {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "activityDetailCell") as? ActivityDescriptionCell, let curActivity = activitiesFetchedResultsController?.object(at: indexPath) else { return UITableViewCell() }
            cell.configureWithActivity(activity: curActivity)
            cell.activityComplete.onTap = {
                checkboxTapClosure(curActivity, cell)
            }
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "activitySummaryCell") as? ActivitySummaryCell, let curActivity = activitiesFetchedResultsController?.object(at: indexPath) else { return UITableViewCell() }
        
        cell.configureWithActivity(activity: curActivity)
        cell.activityComplete.onTap = {
            checkboxTapClosure(curActivity, cell)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tableView = tableView as? MinMaxTableView, let curActivityName = activitiesFetchedResultsController?.object(at: indexPath).name, indexPath != tableView.maximizedRow {
            TextToSpeech.speak(msg: curActivityName)
            tableView.maximizedRow = indexPath
        }

    }
    
}

extension LandingPageVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            activitiesTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            activitiesTableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            activitiesTableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            activitiesTableView.reloadRows(at: [indexPath!], with: .automatic)
        @unknown default:
            return
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        activitiesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        activitiesTableView.endUpdates()
    }
}
