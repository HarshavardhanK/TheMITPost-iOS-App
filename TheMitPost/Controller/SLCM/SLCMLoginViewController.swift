//
//  SecondViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 14/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import LocalAuthentication

import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class SLCMLoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    let SLCMAPI: String = "https://app.themitpost.com/values"

    @IBOutlet weak var registrationTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var passwordHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var biometricLabel: UILabel!
    
    
    //var activityIndicator: NVActivityIndicatorView!
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    
    var subjects = [Subject]()
    
    var result = false
    
    var count: Int = 0 // counting invalid attempts
    
    func authenticateWithBiometric(completion: @escaping (Bool) -> ())  {
        
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {

                    if success {
                        completion(true)
                    } else {
                        //invalid authentication error
                        
                        completion(false)
                    }
                }
                
               
            }
        } else {
            // no biometry
            
        }
        
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        self.startActivityIndicator()
        
        signInButton.isEnabled = false
        
        if checkForBiometric() {
            
            authenticateWithBiometric { (success) in
                
                if success {
                    
                    guard let registration = UserDefaults.standard.string(forKey: "registration") else {
                        return
                    }
                    
                    guard let password = UserDefaults.standard.string(forKey: "password") else {
                        return
                    }
                    
                    self.loadSLCMData (registration: registration, password: password) { (result) in
                            
                            if result {
                                
                                self.stopActivityIndicator()
                                
                                self.performSegue(withIdentifier: "slcmDetail", sender: self)
                                
                            } else {
                                
                                self.showAlertForInvalidCredentials()
                               
                                self.count += 1
                                
                                UserDefaults.standard.set(self.count, forKey: ERROR_CODES.INVALID_ATTEMPT)
                                
                                self.stopActivityIndicator()
                                
                    //            if self.count == 2 {
                    //                UserDefaults.standard.set(Date(), forKey: ERROR_CODES.TIME_OF_INVALID)
                    //            }
                              }
                                
                                self.signInButton.isEnabled = true
                            }
                            
                    self.passwordTextfield.text = nil
                    self.registrationTextfield.text = nil
                    
                }
                
            }
            
        } else {
            
            guard let registration = registrationTextfield.text else {
                return
            }

            guard let password = passwordTextfield.text else {
                return
            }
            
            self.passwordTextfield.text = nil
            self.registrationTextfield.text = nil
            
            loadSLCMData (registration: registration, password: password){ (result) in
                    
                    if result {
                        
                        self.stopActivityIndicator()
                        
                        print("Storing \(registration)")
                        print("Storing \(password)")
                        
                        UserDefaults.standard.set(registration, forKey: "registration")
                        UserDefaults.standard.set(password, forKey: "password")
                        
                        self.performSegue(withIdentifier: "slcmDetail", sender: self)
                        
                    } else {
                        
                        self.showAlertForInvalidCredentials()
                       
                        self.count += 1
                        
                        UserDefaults.standard.set(self.count, forKey: ERROR_CODES.INVALID_ATTEMPT)
                        
                        self.stopActivityIndicator()
                        
            //            if self.count == 2 {
            //                UserDefaults.standard.set(Date(), forKey: ERROR_CODES.TIME_OF_INVALID)
            //            }
                      }
                        
                        self.signInButton.isEnabled = true
                    }
            
            UserDefaults.standard.set(true, forKey: "userSaved")
        }
    }

    
    func checkForBiometric() -> Bool {
        
        let isUserSaved = UserDefaults.standard.bool(forKey: "userSaved")
        
        if isUserSaved {
            
            return true
        }
        
        return false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    var passwordFound = true
    var registrationFound = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()
        
        registrationTextfield.delegate = self
        passwordTextfield.delegate = self
        
        signInButton.layer.cornerRadius = 4
        
        registrationTextfield.keyboardType = .numberPad
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if checkForBiometric() {
            print("biometric is enabled")
            biometricLabel.text = "Face ID is enabled"
            biometricLabel.textColor = .tertiaryLabel
            
        } else {
            print("biometric is disabled")
        }
        
        guard let registration = UserDefaults.standard.string(forKey: "registration") else {
            registrationFound = false
            passwordFound = false
            return
        }
        
        guard let password = UserDefaults.standard.string(forKey: "password") else {
            passwordFound = false
            return
        }
        
        registrationTextfield.text = registration
        passwordTextfield.text = password
        
        registrationTextfield.isEnabled = false
        passwordTextfield.isEnabled = false
        
    }
    
    //MARK: UI THEME
    func mode() {
        
        if traitCollection.userInterfaceStyle == .dark {
            self.navigationController?.navigationBar.barTintColor = .background
            self.view.backgroundColor = .background
            signInButton.backgroundColor = .background
            
        } else {
            self.navigationController?.navigationBar.barTintColor = .systemOrange
            self.view.backgroundColor = .white
            signInButton.backgroundColor = .white
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
       mode()
    }
    
    func resetInvalidLock() -> Bool {
        
        let now = Date()
        
        guard let invalidDate = UserDefaults.standard.object(forKey: ERROR_CODES.TIME_OF_INVALID) else {
            print("No date object found")
            return false
        }
        
        let diff = now.timeIntervalSince(invalidDate as! Date)
        
        let minutes = diff
        print(diff) // it is in seconds. make it minutes
        
        if(minutes >= 20) {
            print("lock lifted")
            return true
        }
        
        return false
    }
    
    func showAlertForInvalidCredentials() {
        
        let invalidAlert = UIAlertController(title: "Invalid credentials", message: "Check your registration/password, and try again", preferredStyle: .alert)
        
        invalidAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            //add code to limit the number of invalid attempts
        }))
        
        self.present(invalidAlert, animated: true, completion: nil)
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
    
    
    func loadSLCMData(registration: String, password: String, completion: @escaping (Bool) -> ()) {
        
        var success = false
        
        print("registration is \(registration)")
        print("password is \(password)")
        
        Alamofire.request(self.SLCMAPI, method: .post, parameters:["regNumber":registration, "pass":password], encoding: JSONEncoding.default).responseJSON { response in
            
            print("calling post request")
            
            guard let resultValue = response.result.value else {
                print("Failing in website")
                completion(false)
                //sendinf false would mean invalid login. Change it
                //code to send error alert
                return
            }
            
            let data = JSON(resultValue)
            print(data)
            
            if data["message"].stringValue == "Invalid Credentials" {
                
                print(data["message"].stringValue)
                print("Actually invalid")
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
        print("Text field has text \(textField.text ?? "NA")")
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
    
    @IBAction func unwindFromSLCM(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? SLCMTableViewController {
            print("Unwinding back to SLCM login")
        }
    }
    

}



/*loadSLCMData { (result) in
        
        if result {
            
            self.stopActivityIndicator()
            
            self.performSegue(withIdentifier: "slcmDetail", sender: self)
            
        } else {
            
            self.showAlertForInvalidCredentials()
           
            self.count += 1
            
            UserDefaults.standard.set(self.count, forKey: ERROR_CODES.INVALID_ATTEMPT)
            
            self.stopActivityIndicator()
            
//            if self.count == 2 {
//                UserDefaults.standard.set(Date(), forKey: ERROR_CODES.TIME_OF_INVALID)
//            }
          }
            
            self.signInButton.isEnabled = true
        }
        
        passwordTextfield.text = nil
        registrationTextfield.text = nil
        
    }
        
       /* if resetInvalidLock() {
            
            UserDefaults.standard.set(nil, forKey: ERROR_CODES.TIME_OF_INVALID)
            UserDefaults.standard.set(0, forKey: ERROR_CODES.INVALID_ATTEMPT)
        }
        
        count = UserDefaults.standard.integer(forKey: ERROR_CODES.INVALID_ATTEMPT)
       
        
        if count < 2 {
            
            startActivityIndicator()
            
            loadSLCMData { (result) in
                
                if result {
                    
                    self.stopActivityIndicator()
                    
                    self.performSegue(withIdentifier: "slcmDetail", sender: self)
                    
                } else {
                    
                    self.showAlertForInvalidCredentials()
                   
                    self.count += 1
                    
                    UserDefaults.standard.set(self.count, forKey: ERROR_CODES.INVALID_ATTEMPT)
                    
                    self.stopActivityIndicator()
                    
                    if self.count == 2 {
                        UserDefaults.standard.set(Date(), forKey: ERROR_CODES.TIME_OF_INVALID)
                    }
                }
                
            }
            
        } else {
            
            let moreInvalidAttempts = UIAlertController(title: "Too many failed logins", message: "You have exhausted the limit for failed logins. Try again after 20 minutes", preferredStyle: .alert)
            
            moreInvalidAttempts.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //start timer
            }))
            
            self.present(moreInvalidAttempts, animated: true, completion: nil)
            
        }*/
        
        
    //}*/

