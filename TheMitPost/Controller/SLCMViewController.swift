//
//  SecondViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 14/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SLCMViewController: UIViewController, UITextFieldDelegate {
    
    let SLCMAPI: String = "https://api.themitpost.com/values"
    
    var pass = "FHJ-CSd-5rc-f5A"

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var passwordHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInHorizontalConstraint: NSLayoutConstraint!
    @IBAction func signInPressed(_ sender: Any) {
        
        animateIntoView(duration: 1.3, delay: 0.3, margin: view.bounds.width)
        
        UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            
            self.signInHorizontalConstraint.constant -= self.view.bounds.width
            self.stackView.layoutSubviews()
            
        }) { (true) in
            
            print("Login successfull")
            
            
            
            Alamofire.request(self.SLCMAPI, method: .post, parameters:["regNumber": "170905022", "pass":"FHJ-CSd-5rc-f5A"], encoding: JSONEncoding.default).responseJSON { response in
                
                let data = JSON(response.result.value)
                print(data)
                
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func animateIntoView(duration: Double, delay: Double, margin: CGFloat) {
        
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseOut], animations: {
            
            self.passwordHorizontalConstraint.constant -= margin
            self.usernameHorizontalConstraint.constant -= margin
            
            self.stackView.layoutSubviews()
            
        }) { (true) in
            print("Animation successfull")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }


}

