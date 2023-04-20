//
//  MinMaxTableView.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/6/23.
//

import UIKit

class MinMaxTableView: UITableView {

    private var maximizedRow_: IndexPath?
    
    public var maximizedRow: IndexPath? {
        get {
            return maximizedRow_
        } set {
            let oldValue = maximizedRow_
            maximizedRow_ = newValue
            
            if (oldValue == newValue) {
                maximizedRow_ = nil
            }
            
            if let oldValue = oldValue {
                reloadRows(at: [oldValue], with: .automatic)
            }
            
            if let maximizedRow_ = maximizedRow_ {
                reloadRows(at: [maximizedRow_], with: .automatic)
            }
        }
    }

}
