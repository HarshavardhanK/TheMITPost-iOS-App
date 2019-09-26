//
//  SLCMSettingsViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 26/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import Locksmith

class SLCMSettingsViewController: UIViewController {
    
    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func switchBiometric(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
        
        print("log out pressed")
        
        guard let registration = UserDefaults.standard.string(forKey: "registration") else {
            return
        }
               
        try! Locksmith.deleteDataForUserAccount(userAccount: registration)
        
        UserDefaults.standard.set(false, forKey: "userSaved")
        UserDefaults.standard.set(nil, forKey: "registration")
        UserDefaults.standard.set(nil, forKey: "password")
        
        logoutButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _ = UserDefaults.standard.string(forKey: "registration") else {
            logoutButton.isEnabled = false
            return
        }
        
    }
    
    //MARK: ALERTS
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("settings controller loaded")
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
