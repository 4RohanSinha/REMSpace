//
//  ActivityRecommender.swift
//  REMSpace
//
//  Created by Rohan Sinha on 3/15/23.
//

import Foundation
import CoreData

class ActivityRecommender {
    static private var recommendedActivities_: [Activity] = []
    static var dataController: DataController?
    
    static var recommendedActivities: [Activity] {
        updateRecommendations()
        return recommendedActivities_
    }
    
    class func updateRecommendations() {
        let actFetchRequest = Activity.fetchRequest()
        if let savedRecommendations = try? actFetchRequest.execute() {
            recommendedActivities_ = savedRecommendations
        }
        
        if let dataController = dataController, recommendedActivities_.count == 0 {
            let actOne = Activity(viewContext: dataController.viewContext, name: "Running", description: "", date: Date())
            let actTwo = Activity(viewContext: dataController.viewContext, name: "Drawing", description: "", date: Date())
            let actThree = Activity(viewContext: dataController.viewContext, name: "Sleeping", description: "", date: Date())
            
            recommendedActivities_.append(contentsOf: [actOne, actTwo, actThree])
            
            try? dataController.viewContext.save()

        }
    }
}
