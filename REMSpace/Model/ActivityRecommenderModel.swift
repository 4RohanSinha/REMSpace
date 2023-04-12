//
//  ActivityRecommenderModel.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/10/23.
//

import Foundation
import CoreML


class ActivityRecommenderInterface {
    var recommendedActivities: [Activity] = [Activity]()
    
    class func load() {
        let recommender = ActivityRecommenderV1()
        //print(recommender.model)
        print(recommender.model.modelDescription.inputDescriptionsByName["items"]!.name)
        print(recommender.model.modelDescription.classLabels)
        //let input = ActivityRecommenderV1Input(items: <#T##[String : Double]#>, k: <#T##Int64#>)
        //let input = ActivityRecommenderV1_1Input(items: <#T##[String : Double]#>, k: <#T##Int64#>)
    }
}
