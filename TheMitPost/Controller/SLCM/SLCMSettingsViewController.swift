//
//  SLCMSettingsViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 26/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import LocalAuthentication

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
    
    var biometricLabel: UILabel?
    let context = LAContext()
    
    @IBAction func biometricSwitchAction(_ sender: UISwitch) {
        
        var laTypeString = "Touch ID"
        
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType {
            
        case .none:
            laTypeString = ""
            
        case .faceID:
            laTypeString = "Face ID is enabled"
            
        case .touchID:
            laTypeString = "Touch ID is enabled"
            
        default:
            laTypeString = ""
            
        }
        
        
        if sender.isOn {
            
            print("Switch on")
            UserDefaults.standard.set(true, forKey: "biometricEnabled")
            biometricLabel?.text = laTypeString
            
        } else {
            UserDefaults.standard.set(false, forKey: "biometricEnabled")
            print("Switch off")
            biometricLabel?.text = nil
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
        
        var laTypeString = "Touch ID"
        
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType {
            
        case .none:
            laTypeString = ""
            
        case .faceID:
            laTypeString = "Require Face ID"
            
        case .touchID:
            laTypeString = "Require Touch ID"
            
        default:
            laTypeString = ""
            
        }
        
        biometricTypeLabel.text = laTypeString
        
        lottieSettingsView.play()
        biometricLottieView.play()
        jumboLottieView.play()
        
        if UserDefaults.standard.bool(forKey: "biometricEnabled") {
            biometricSwitch.setOn(true, animated: true)
            
        } else {
            biometricSwitch.setOn(false, animated: true)
        }
       
        guard let _ = UserDefaults.standard.string(forKey: DEFAULTS.REGISTRATION) else {
            logoutButton.isEnabled = false
            return
        }
        
        print("settings controller loaded")
        
        
        
    }
    
    //MARK: UI THEME
    func mode() {
        
        if #available(iOS 13, *) {
            
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
        
        
    }
    
    //@available(iOS 13, *)
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13, *) {
            mode()
        }
    }

}
