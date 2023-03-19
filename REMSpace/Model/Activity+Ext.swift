//
//  Activity+Ext.swift
//  REMSpace
//
//  Created by Rohan Sinha on 3/15/23.
//

import Foundation
import CoreData

extension Activity {
    convenience init(viewContext: NSManagedObjectContext, name: String, description: String, date: Date) {
        self.init(context: viewContext)
        self.name = name
        self.actDescr = description
        self.date = date
        self.isComplete = false
    }
}
