//
//  PageControlIdxManager.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/19/23.
//

import Foundation
import UIKit

class SleepStatsGraphIdxManager {
    private var totalNumItems: Int
    private var startingBound: Int
    private var endingBound: Int
    private var currentIdx_: Int?
    
    
    var currentIdx: Int? {
        get {
            return currentIdx_
        } set {
            
        }
    }
    
    init(totalNumItems: Int, startingBound: Int?, endingBound: Int?) {
        self.totalNumItems = totalNumItems
        self.startingBound = startingBound ?? ((endingBound ?? 3) - 3)
        self.endingBound = endingBound ?? ((startingBound ?? 3) + 3)
    }
    
    
}
