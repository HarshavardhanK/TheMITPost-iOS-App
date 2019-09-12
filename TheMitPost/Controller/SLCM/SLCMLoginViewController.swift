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

class SLCMLoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    let SLCMAPI: String = "https://api.themitpost.com/values"

    @IBOutlet weak var registrationTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var passwordHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInButton: UIButton!
    
    //var activityIndicator: NVActivityIndicatorView!
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    
    var subjects = [Subject]()
    
    var result = false
    
    @IBAction func signInPressed(_ sender: Any) {
        
        startActivityIndicator()
        
        loadSLCMData { (result) in
            
            if result {
                self.stopActivityIndicator()
                
                self.performSegue(withIdentifier: "slcmDetail", sender: self)
                
            } else {
                print("Invalid credentials")
                self.stopActivityIndicator()
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK:- Activty Indicator NVActivityIndicatorView
    
    func startActivityIndicator() {
        
        let types = [NVActivityIndicatorType.ballScaleRippleMultiple, NVActivityIndicatorType.ballBeat, NVActivityIndicatorType.ballScale, NVActivityIndicatorType.ballPulseSync]
        
        let index: Int = Int(arc4random()) % 4
        
        activityIndicator.type = types[index]
        
        activityIndicator.color = UIColor.orange
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func stopActivityIndicator() {
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
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
        
        signInButton.layer.cornerRadius = 5
        
        registrationTextfield.keyboardType = .numberPad
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    func loadSLCMData(completion: @escaping (Bool) -> ()) {
        
        var success = false
        
        guard let registration = registrationTextfield.text else {
            return
        }

        guard let password = passwordTextfield.text else {
            return
        }
        
        Alamofire.request(self.SLCMAPI, method: .post, parameters:["regNumber":registration, "pass":password], encoding: JSONEncoding.default).responseJSON { response in
            
            print("calling post request")
            let data = JSON(response.result.value)
            
            if data["message"].stringValue == "Invalid Credentials" {
                
                print(data["message"].stringValue)
                success = false
                
            } else {
        
                print("Credentials are right..")
                success = true
                
                guard let _subjects = groupData(data: data["academicDetails"][0]) else {
                    print("Failing to group")
                    return
                }
                
                print(self.subjects.count)
                
                _subjects[0].display()
                
                self.subjects = _subjects
            
            }
            
            print("Completed POST request")
            
            completion(success)
            
        }
        
       
    }
    
    //MARK:- UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("text field being edited..")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("text field ended editing..")
        print("Text field has text \(textField.text)")
        resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    
    //MARK:- Perform segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "slcmDetail" {
                
            print("Passed subjects..")
                
            print("Segueing to SLCM Detail")
            
            
            let destination = segue.destination as! SLCMTableViewController
            destination.subjects = self.subjects
                
                
        }
        
    }
    

}

