//
//  AboutViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 03/10/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

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
        
        mode()
        // Do any additional setup after loading the view.
        privacyPolicyButton.layer.cornerRadius = 8
        self.view.layer.cornerRadius = 20
        //self.topThingView.layer.cornerRadius = self.topThingView.frame.width / 2 - 10
        
        //MARK: Round Image
        self.clubImageView.backgroundColor = .white
        self.clubImageView.layer.borderColor = UIColor.white.cgColor
        self.clubImageView.layer.borderWidth = 0.70
        self.clubImageView.layer.cornerRadius = clubImageView.frame.width / 2
        clubImageView.clipsToBounds = true
        
        self.developerImageView.backgroundColor = .white
        self.developerImageView.layer.borderColor = UIColor.white.cgColor
        self.developerImageView.layer.borderWidth = 0.70
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
        
        let devImages = ["harsha1", "harsha2", "harsha3"]
        let name = devImages[Int(arc4random()) % 3]
        developerImageView.image = UIImage(named: name)
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
                
                developerImageView.layer.borderColor = UIColor.white.cgColor
                developerImageView.backgroundColor = .background
                clubImageView.layer.borderColor = UIColor.white.cgColor
                clubImageView.backgroundColor = .background
                
            } else {
                
                view.backgroundColor = .white
                topThingView.backgroundColor = .white
                
                developerImageView.layer.borderColor = UIColor.lightGray.cgColor
                developerImageView.backgroundColor = .white
                clubImageView.layer.borderColor = UIColor.lightGray.cgColor
                clubImageView.backgroundColor = .white
                
            }
            
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        mode()
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
