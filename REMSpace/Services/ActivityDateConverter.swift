//
//  ActivityDateConverter.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/19/23.
//

import Foundation

class ActivityDateConverter {
    static private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }
    
    class func getDateFromString(string: String) -> Date {
        return dateFormatter.date(from: string)!
    }
    
    class func getStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
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
    
}
