//
//  SLCMSettingsViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 26/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

import NotificationBannerSwift
import Locksmith

class SLCMSettingsViewController: UIViewController {
    
    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func switchBiometric(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
        
        print("log out pressed")
        
    }

    
    //MARK: ALERTS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = UserDefaults.standard.string(forKey: "registration") else {
            logoutButton.isEnabled = false
            return
        }
        
        print("settings controller loaded")
        
    }

}
