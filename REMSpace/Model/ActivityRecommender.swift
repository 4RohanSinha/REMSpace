//
//  ActivityRecommender.swift
//  REMSpace
//
//  Created by Rohan Sinha on 3/15/23.
//

import Foundation
import CoreData

class ActivityRecommender {
    static var dataController: DataController?
    
    class func initialize(dataController: DataController) {
        self.dataController = dataController
    }
    
    class func getStartAndEndDates(date: Date) -> (Date, Date) {
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
    
    class func updateRecommendations() {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let dateRange = getStartAndEndDates(date: Date())
        
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", dateRange.0 as CVarArg, dateRange.1 as CVarArg)
        
        guard let activities = try? dataController?.viewContext.fetch(fetchRequest) as? [Activity], activities.count == 0 else { return }
        
        if let dataController = dataController {
            let actOne = Activity(viewContext: dataController.viewContext, name: "Write Your Own Story", description: "Let your creative juices flow and write your own book, story, play, or musical", date: Date())
            let actTwo = Activity(viewContext: dataController.viewContext, name: "Engage in a Social gathering", description: "Join a community or a club like a baking group or a book club", date: Date())
            let actThree = Activity(viewContext: dataController.viewContext, name: "Go to a museum", description: "Find a local museum or history center and take a tour", date: Date())
            try? dataController.viewContext.save()

        }
    }
}
