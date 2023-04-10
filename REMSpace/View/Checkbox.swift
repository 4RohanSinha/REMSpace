//
//  Checkbox.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/6/23.
//

import UIKit

class Checkbox: UIButton {
    var isOn_: Bool = false
    
    var isOn: Bool {
        get {
            return isOn_
        } set {
            isOn_ = newValue
            if (newValue) {
                setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            } else {
                setImage(UIImage(systemName: "square"), for: .normal)

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle("", for: .normal)
        
        isOn = false
        addTarget(self, action: #selector(switchState), for: .touchUpInside)
    }
    
    @objc func switchState() {
        isOn = !isOn
    }

}
