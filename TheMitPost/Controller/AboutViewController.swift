//
//  AboutViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 03/10/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

import MaterialComponents
import Crashlytics

class AboutViewController: UIViewController {
    
    @IBOutlet var topThingView: UIView!
    @IBOutlet var clubNameLabel: UILabel!
    @IBOutlet var clubImageView: UIImageView!
    @IBOutlet var developerImageView: UIImageView!
    
    @IBOutlet var devInstagram: UIImageView!
    @IBOutlet var devFacebook: UIImageView!
    @IBOutlet var devGitHub: UIImageView!
    
    @IBOutlet var instagramHandle: UIImageView!
    @IBOutlet var facebookHandle: UIImageView!
    
    @IBOutlet var privacyPolicyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 250, width: 100, height: 30)
//        button.setTitle("Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(button)
        
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicy(_:)), for: .touchUpInside)
        
        mode()
        // Do any additional setup after loading the view.
        privacyPolicyButton.layer.cornerRadius = 8
        privacyPolicyButton.layer.shadowRadius = 5
        
        self.view.layer.cornerRadius = 20
        //self.topThingView.layer.cornerRadius = self.topThingView.frame.width / 2 - 10
        
        //MARK: Round Image
        self.clubImageView.backgroundColor = .white
        self.clubImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.clubImageView.layer.borderWidth = 0.30
        self.clubImageView.layer.cornerRadius = clubImageView.frame.width / 2
        clubImageView.clipsToBounds = true
        
        self.developerImageView.backgroundColor = .white
        self.developerImageView.layer.borderColor = UIColor.white.cgColor
        self.developerImageView.layer.borderWidth = 0.30
        self.developerImageView.layer.cornerRadius = developerImageView.frame.width / 2
        
        developerImageView.clipsToBounds = true
        
        devGitHub.layer.cornerRadius = devGitHub.frame.width / 2
        
        
        devFacebook.isUserInteractionEnabled = true
        devFacebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(devFacebookTap)))
        
        devInstagram.isUserInteractionEnabled = true
        devInstagram.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(devInstagramTap)))
        
        devGitHub.isUserInteractionEnabled = true
        devGitHub.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(devGitHubTap)))
        
        
        facebookHandle.isUserInteractionEnabled = true
        facebookHandle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookTap)))
        
        instagramHandle.isUserInteractionEnabled = true
        instagramHandle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramTap)))
        
        developerImageView.image = UIImage(named: "harsha1")
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    //MARK: Tap on social media
    @objc func devFacebookTap() {
        print("Tap on facebook developer")
        UIApplication.shared.open(URL(string: "https://www.facebook.com/harshavardhan.kalalbandi")!)
    }
    
    @objc func devInstagramTap() {
        print("Tap on facebook developer")
        UIApplication.shared.open(URL(string: "https://www.instagram.com/tsarshah")!)
    }
    
    @objc func devGitHubTap() {
        print("Tap on facebook developer")
        UIApplication.shared.open(URL(string: "https://www.github.com/HarshavardhanK")!)
    }
    
    @objc func facebookTap() {
        print("Tap on facebook developer")
        UIApplication.shared.open(URL(string: "https://www.facebook.com/themitpost/")!)
    }
    
    @objc func instagramTap() {
        print("Tap on facebook developer")
        UIApplication.shared.open(URL(string: "https://www.instagram.com/themitpost")!)
    }
    
    //MARK: UI THEME
    func mode() {
        
        if #available(iOS 13, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                view.backgroundColor = .background
                topThingView.backgroundColor = .black
                
                developerImageView.layer.borderColor = UIColor.lightGray.cgColor
                developerImageView.backgroundColor = .background
                clubImageView.layer.borderColor = UIColor.lightGray.cgColor
                clubImageView.backgroundColor = .background
                privacyPolicyButton.backgroundColor = .background
                
            } else {
                
                view.backgroundColor = .white
                topThingView.backgroundColor = .white
                
                developerImageView.layer.borderColor = UIColor.lightGray.cgColor
                developerImageView.backgroundColor = .white
                clubImageView.layer.borderColor = UIColor.lightGray.cgColor
                clubImageView.backgroundColor = .white
                privacyPolicyButton.backgroundColor = .white
                
            }
            
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        mode()
    }
    
    @objc func privacyPolicy(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
            
            guard let privacyController = storyboard?.instantiateViewController(identifier: "privacy") as? PrivacyViewController else {
                return
            }
            
            if traitCollection.userInterfaceStyle == .dark {
                privacyController.url = URL(string: "https://app.themitpost.com/policy/dark")
                       
            } else {
                privacyController.url = URL(string: "https://app.themitpost.com/policy")
            }
            
            
            let sheet = MDCBottomSheetController(contentViewController: privacyController)
            sheet.preferredContentSize = CGSize(width: self.view.frame.width, height: 500.0)
            
            present(sheet, animated: true, completion: nil)
            
            
        } else {
           
            guard let privacyController = storyboard?.instantiateViewController(withIdentifier: "privacy") as? PrivacyViewController else {
                return
            }
            
            if traitCollection.userInterfaceStyle == .dark {
                privacyController.url = URL(string: "https://app.themitpost.com/policy/dark")
                       
            } else {
                privacyController.url = URL(string: "https://app.themitpost.com/policy")
            }
            
            let sheet = MDCBottomSheetController(contentViewController: privacyController)
            sheet.preferredContentSize = CGSize(width: self.view.frame.width, height: 500.0)
            
            present(sheet, animated: true, completion: nil)
            
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "privacySegue" {
            
            if let destinationViewController = segue.destination as? PDFLoadViewController {
                
                if traitCollection.userInterfaceStyle == .dark {
                    destinationViewController.url = URL(string: "https://app.themitpost.com/policy/dark")
                    
                } else {
                    destinationViewController.url = URL(string: "https://app.themitpost.com/policy")
                }
                
            }
        }
    }
    

}
