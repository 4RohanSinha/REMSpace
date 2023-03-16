//
//  ActivityRecommenderVC.swift
//  REMSpace
//
//  Created by Rohan Sinha on 3/12/23.
//

import UIKit

class ActivityRecommenderVC: UIViewController {
    
    @IBOutlet weak var activitiesTableView: UITableView!
    var latestRecommendations: [Activity] = ActivityRecommender.recommendedActivities
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ActivityRecommenderVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        latestRecommendations = ActivityRecommender.recommendedActivities
        return latestRecommendations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
