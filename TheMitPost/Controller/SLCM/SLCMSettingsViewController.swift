//
//  SLCMSettingsViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 26/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

import Lottie
import NotificationBannerSwift
import Locksmith

class SLCMSettingsViewController: UIViewController {
    
    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var lottieSettingsView: AnimationView!
    
    @IBOutlet var biometricLottieView: AnimationView!
    @IBOutlet var jumboLottieView: AnimationView!
    
    @IBOutlet weak var topThingView: UIView!
    @IBAction func switchBiometric(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
        
        print("log out pressed")
        
    }

    
    //MARK: ALERTS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 20
        self.topThingView.layer.cornerRadius = 5
        
        lottieSettingsView.backgroundColor = .white
        biometricLottieView.backgroundColor = .white
        jumboLottieView.backgroundColor = .white
        
        lottieSettingsView.play()
        biometricLottieView.play()
        jumboLottieView.play()
        
        
        guard let _ = UserDefaults.standard.string(forKey: "registration") else {
            logoutButton.isEnabled = false
            return
        }
        
        print("settings controller loaded")
        
    }
    
    //

}
