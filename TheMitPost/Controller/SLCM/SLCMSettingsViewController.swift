//
//  SLCMSettingsViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 26/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import LocalAuthentication

import SwiftyJSON
import Alamofire
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
    
    
    @IBAction func purgeAccountAction(_ sender: Any) {
        
        let url = "https://app.themitpost.com/slcm/purge"
        
        guard let registration = UserDefaults.standard.string(forKey: DEFAULTS.REGISTRATION) else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: ["regNumber": registration], encoding: JSONEncoding.default).responseJSON { (response) in
            
            if let resp = response.result.value {
                
                let data = JSON(resp)
                
                if data["status"] == "OK" {
                    //success
                    let banner = NotificationBanner(title: "Deleted", subtitle: "Successfully deleted your account from our server", style: .success)
                    banner.show()
                    
                } else {
                    
                    let banner = NotificationBanner(title: "Uh oh", subtitle: "There was an error trying to delete your account", style: .warning)
                    banner.show()
                }
                
            } else {
                
                let banner = NotificationBanner(title: "Try again", subtitle: "There was an error trying to delete your account", style: .warning)
                banner.show()
                
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    //MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()
        
        self.view.layer.cornerRadius = 15
        
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
        
        var names: [String]
        
        if traitCollection.userInterfaceStyle == .dark {
            names = ["particle-explosion", "vui", "force", "batman"]
            
            let animation = Animation.named("settings-gear")
            lottieSettingsView.animation = animation
            lottieSettingsView.loopMode = .loop
            lottieSettingsView.play()
            
        } else {
            names = ["bear", "biking", "fat-cat", "doggie", "funky-chicken", "jumping_girl", "jumbo-typing"]
            
            let animation = Animation.named("gears2", subdirectory: "Lottie-Files")
            lottieSettingsView.animation = animation
            lottieSettingsView.loopMode = .loop
            lottieSettingsView.play()
        }
        
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
                
                setupLottieViews()
                
                lottieView.backgroundColor = .background
                
            } else {
                
                setupLottieViews()
                
                topThing.image = UIImage(named: "topThingGray")
                view.backgroundColor = .white
                lottieSettingsView.backgroundColor = .white
                biometricLottieView.backgroundColor = .white
                lottieView.backgroundColor = .white
                
            }
            
        } else {
            setupLottieViews()
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
