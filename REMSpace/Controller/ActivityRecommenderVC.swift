//
//  ActivityRecommenderVC.swift
//  REMSpace
//
//  Created by Rohan Sinha on 3/12/23.
//

import UIKit
import CoreData


class ActivityRecommenderVC: CoreDataStackViewController {
    
    @IBOutlet weak var activitiesTableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<Activity>?
    @IBOutlet weak var signInNoticeBtn: UIButton!
    
    func configureFetchedResultsController() {
        guard let dataController = dataController else { return }

        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //let todayPredicate = NSPredicate(format: "date == %@", Date() as CVarArg)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Error fetching activities")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityRecommender.dataController = dataController
        ActivityRecommender.updateRecommendations()
        
        activitiesTableView.dataSource = self
        activitiesTableView.delegate = self
        
        configureFetchedResultsController()
        
        
        activitiesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        signInNoticeBtn.isHidden = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        configureFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController?.delegate = nil
        fetchedResultsController = nil
    }

}

extension ActivityRecommenderVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let objCount = fetchedResultsController?.sections?[section].numberOfObjects

        if (objCount == 0) {
            ActivityRecommender.updateRecommendations()
        }

        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "activityRecommendationCell") as? ActivityRecommendationCell, let curActivity = fetchedResultsController?.object(at: indexPath) else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.configure(withActivity: curActivity)
        
        return cell
    }
    
}

extension ActivityRecommenderVC: NSFetchedResultsControllerDelegate {
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
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        activitiesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        activitiesTableView.endUpdates()
    }
}
