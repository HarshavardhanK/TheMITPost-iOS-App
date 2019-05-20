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
import NVActivityIndicatorView

class SLCMViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    let SLCMAPI: String = "https://api.themitpost.com/values"

    @IBOutlet weak var registrationTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var passwordHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInHorizontalConstraint: NSLayoutConstraint!
    
    var subjects = [Subject]()
    
    
    @IBAction func signInPressed(_ sender: Any) {
        
        self.startActivityIndicator()
        
        self.loadSLCMData() { result in
            
            if result {
                 self.performSegue(withIdentifier: "slcmDetail", sender: self)
            } else {
                print("Wrong credentials")
            }
            
            self.stopActivityIndicator()
        }
        

    }
    
    var activityIndicator: NVActivityIndicatorView!
    
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
        
        registrationTextfield.delegate = self
        passwordTextfield.delegate = self
        
        if let _registration = registrationTextfield.text {
            print(_registration)
        }
        
        if let _password = passwordTextfield.text {
            print(_password)
        }
        
        registrationTextfield.keyboardType = .numberPad
        
    }
    
    func loadSLCMData(completion: @escaping (Bool) -> ()) {
        
        var success = false
        
        var registration = ""
        var password = ""
        
        if let _registration = registrationTextfield.text {
            registration = _registration
        }
        
        if let _password = passwordTextfield.text {
            password = _password
        }
        
        Alamofire.request(self.SLCMAPI, method: .post, parameters:["regNumber":registration, "pass":password], encoding: JSONEncoding.default).responseJSON { response in
            
            
            let data = JSON(response.result.value)
            print(data)
            
            if !data["status"].boolValue {
                
                print(data["message"].stringValue)
                success = false
                
            } else {
        
                print("Credentials are right..")
                success = true
                
                var _ = Marks(data: data["marks"][0])
                
                self.subjects = Subject.segragateMarksAndAttendance(data: data)
                
                self.subjects[0].display()
            
            }
            
            completion(success)
            
            
            
        }
        
       
    }
    
    //MARK:- UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("text field being edited..")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("text field ended editing..")
        resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK:- Activty Indicator NVActivityIndicatorView
    
    func startActivityIndicator() {
        
        let frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 50.0, height: 50.0)
        
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = .ballZigZag
        activityIndicator.color = UIColor.orange
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func stopActivityIndicator() {
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
    }
    
    //MARK:- Perform segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "slcmDetail" {
            print("Segueing to SLCM Detail")
            
            
        }
    }
    
    


}

