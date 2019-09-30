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
    
    
    @IBOutlet var settingLabel: UILabel!
    @IBOutlet var biometricTypeLabel: UILabel!
    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var lottieSettingsView: AnimationView!
    
    @IBOutlet var biometricLottieView: AnimationView!
    @IBOutlet var jumboLottieView: AnimationView!
    
    @IBOutlet weak var topThingView: UIView!
    
    @IBAction func biometricSwitchAction(_ sender: UISwitch) {
        
        if sender.isOn {
            print("Switch on")
            UserDefaults.standard.set(true, forKey: "biometricEnabled")
            
        } else {
            UserDefaults.standard.set(false, forKey: "biometricEnabled")
            print("Swtich off")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    //MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 20
        self.topThingView.layer.cornerRadius = 8
        
        mode()
        
        lottieSettingsView.play()
        biometricLottieView.play()
        jumboLottieView.play()
       
        guard let _ = UserDefaults.standard.string(forKey: "registration") else {
            logoutButton.isEnabled = false
            return
        }
        
        print("settings controller loaded")
        
        
        
    }
    
    //MARK: UI THEME
    func mode() {
        
        biometricTypeLabel.textColor = .secondaryLabel
        
        if traitCollection.userInterfaceStyle == .dark {
            
            view.backgroundColor = .background
            lottieSettingsView.backgroundColor = .background
            biometricLottieView.backgroundColor = .background
            jumboLottieView.backgroundColor = .background
            settingLabel.backgroundColor = .background
            biometricTypeLabel.backgroundColor = .background
            
        } else {
            
            view.backgroundColor = .white
            lottieSettingsView.backgroundColor = .white
            biometricLottieView.backgroundColor = .white
            jumboLottieView.backgroundColor = .white
            settingLabel.backgroundColor = .white
            biometricTypeLabel.backgroundColor = .white
            
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13, *) {
            mode()
        }
    }
    
    //MARK: Face ID Switch Change
    

}
