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
    
    @IBOutlet var topThing: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var lottieSettingsView: AnimationView!
    @IBOutlet var biometricButton: UIButton!
    @IBOutlet var biometricLottieView: AnimationView!
    @IBOutlet var lottieView: AnimationView!
    
    @IBOutlet weak var topThingView: UIImageView!
    
    var biometricLabel: UILabel?
    let context = LAContext()
    
    @IBAction func biometricSwitchAction(_ sender: UIButton) {
        
        let value = UserDefaults.standard.bool(forKey: DEFAULTS.BIOMETRIC_ENABLED)
        
        if value {
            biometricButton.setTitleColor(.systemBlue, for: .normal)
            UserDefaults.standard.set(false, forKey: DEFAULTS.BIOMETRIC_ENABLED)
            biometricButton.setTitle("Require " + biometricType(), for: .normal)
            biometricLabel?.text = nil
            
        } else {
            
            biometricButton.setTitleColor(.systemRed, for: .normal)
            UserDefaults.standard.set(true, forKey: DEFAULTS.BIOMETRIC_ENABLED)
            biometricButton.setTitle("Disable " + biometricType(), for: .normal)
            biometricLabel?.text = biometricType() + " enabled"
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    //MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()
        
        self.view.layer.cornerRadius = 20
        
        setupLottieViews()
        
        let value = UserDefaults.standard.bool(forKey: DEFAULTS.BIOMETRIC_ENABLED)
        
        if value {
            
            biometricButton.setTitleColor(.systemRed, for: .normal)
            biometricButton.setTitle("Disable " + biometricType(), for: .normal)
            biometricLabel?.text = biometricType() + " enabled"
            
        } else {
            
            biometricButton.setTitleColor(.systemBlue, for: .normal)
            biometricButton.setTitle("Require " + biometricType(), for: .normal)
        }
       
        guard let _ = UserDefaults.standard.string(forKey: DEFAULTS.REGISTRATION) else {
            logoutButton.isEnabled = false
            return
        }
        
        print("settings controller loaded")
        
        if !UserDefaults.standard.bool(forKey: "settingsFirstTime") {
            biometricBanner()
            UserDefaults.standard.set(true, forKey: "settingsFirstTime")
        }
        
    }
    
    //MARK: Setup Lottie Views
    func setupLottieViews() {
        
        let names = ["astronaut", "bear", "biking", "fat-cat", "doggie", "funky-chicken", "jumping_girl", "karam", "jumbo-typing", "lumberjack", "body"]
        let name = names[Int(arc4random()) % names.count]
        print(name)
        
        let animation = Animation.named(name, subdirectory: "Lottie-Files")
        lottieView.loopMode = .loop
        lottieView.animation = animation
        lottieView.play()
        
        lottieSettingsView.play()
        lottieSettingsView.loopMode = .loop
        biometricLottieView.loopMode = .loop
        biometricLottieView.play()
        
    }
    
    //MARK: Banners
    func biometricBanner() {
        
        let banner = NotificationBanner(title: "Secure save", subtitle: "You can use " + biometricType() + " to securely login when your credentials are saved on device", style: .info)
        
        banner.show(bannerPosition: .top)
    }
    
    //MARK: Biometric type
    func biometricType() -> String {
        
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType {
            
        case .none:
            return "none"
            
        case .faceID:
            return "Face ID"
            
        case .touchID:
            return "Touch ID"
            
        default:
            return "none"
            
        }
    }
    
    //MARK: UI THEME
    func mode() {
        
        if #available(iOS 13, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                topThing.image = UIImage(named: "topThingWhite")
                view.backgroundColor = .background
                lottieSettingsView.backgroundColor = .background
                biometricLottieView.backgroundColor = .background
                lottieView.backgroundColor = .background
                
            } else {
                
                topThing.image = UIImage(named: "topThingGray")
                view.backgroundColor = .white
                lottieSettingsView.backgroundColor = .white
                biometricLottieView.backgroundColor = .white
                lottieView.backgroundColor = .white
                
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
