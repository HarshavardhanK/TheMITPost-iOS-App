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
        
       // mode()

        // Do any additional setup after loading the view.
        print("settings controller loaded")
        
    }
    
//    func mode() {
//
//        if #available(iOS 13, *) {
//
//            if traitCollection.userInterfaceStyle == .dark {
//                self.view.backgroundColor = .background
//
//            } else {
//                self.view.backgroundColor = .white
//            }
//        }
//    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        mode()
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
