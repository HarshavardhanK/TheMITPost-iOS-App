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
    
    var subjects = [Subject]()
    
    var activityIndicator: NVActivityIndicatorView!
    
    var result = false
    
    @IBAction func signInPressed(_ sender: Any) {
        
        loadSLCMData { (result) in
            
            if result {
              self.performSegue(withIdentifier: "slcmDetail", sender: self)
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
        
        let registration = "170905022"
        let password = "FHJ-CSd-5rc-f5A" // PLEASE REMOVE THIS LATER
        
//        if let _registration = registrationTextfield.text {
//            registration = _registration
//        }
//
//        if let _password = passwordTextfield.text {
//            password = _password
//        }
        
        Alamofire.request(self.SLCMAPI, method: .post, parameters:["regNumber":registration, "pass":password], encoding: JSONEncoding.default).responseJSON { response in
            
            print("calling post request")
            let data = JSON(response.result.value)
            
            if !data["status"].boolValue {
                
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
                
            print("Passed subjects..")
                
            print("Segueing to SLCM Detail")
            
            
            let destination = segue.destination as! SLCMTableViewController
            destination.subjects = self.subjects
                
                
        }
        
    }
    

}
