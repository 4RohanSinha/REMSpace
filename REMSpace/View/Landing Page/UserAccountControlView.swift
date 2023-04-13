//
//  UserAccountControlView.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/6/23.
//

import UIKit

class UserAccountControlView: UIView {

    @IBOutlet weak var isLoggedInIcon: UIImageView!
    @IBOutlet weak var signInIcon: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var explainLbl: UILabel!
    
    var reloadViews: (() -> ())?
    
    func configure() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

        if let emailAddr = UserDefaults.standard.string(forKey: "emailAddr"), isLoggedIn {
            emailLbl.isHidden = false
            emailLbl.text = emailAddr
            isLoggedInIcon.image = UIImage(systemName: "person.circle")
            explainLbl.isHidden = true
            signInIcon.setImage(UIImage(systemName: "info.circle"), for: .normal)
            signInIcon.showsMenuAsPrimaryAction = true
            
            let logoutAction = UIAction(title: "Log out", image: UIImage(systemName: "square.and.arrow.down")) { action in
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.set("", forKey: "emailAddr")
                UserDefaults.standard.set("", forKey: "ouraAccessToken")
                self.reloadViews?()
            }
            
            signInIcon.menu = UIMenu(title: "", children: [logoutAction])
            
        } else {
            emailLbl.text = ""
            emailLbl.isHidden = true
            isLoggedInIcon.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
            explainLbl.isHidden = false
            signInIcon.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            signInIcon.showsMenuAsPrimaryAction = false
        }
    }
}
