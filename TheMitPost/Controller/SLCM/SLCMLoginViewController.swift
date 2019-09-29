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

import Lottie
import NotificationBannerSwift
import NVActivityIndicatorView
import Locksmith
import FittedSheets
import MaterialComponents

class SLCMLoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    let SLCMAPI: String = "https://app.themitpost.com/values"

    @IBOutlet weak var registrationTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
     @IBOutlet weak var biometricLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var securityLottieAnimation: AnimationView!
    
    @IBAction func logoutAction(_ sender: Any) {
        
        presentBottomSettings()
        
        /*showAlertForLogout()
        
        guard let registration = UserDefaults.standard.string(forKey: "registration") else {
            return
        }
               
        try! Locksmith.deleteDataForUserAccount(userAccount: registration)
        
        UserDefaults.standard.set(false, forKey: "userSaved")
        UserDefaults.standard.set(nil, forKey: "registration")
        UserDefaults.standard.set(nil, forKey: "password")
        
        signInButton.isEnabled = false
        
        registrationTextfield.text = nil
        passwordTextfield.text = nil
        
        registrationTextfield.isEnabled = true
        passwordTextfield.isEnabled = true
        
        biometricLabel.text = nil*/
        
    }
    
    
    var subjects = [Subject]()
    
    var result = false
    
    var count: Int = 0 // counting invalid attempts
    
    func authenticateWithBiometric(completion: @escaping (Bool) -> ())  {
        
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "slcm login"

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
    
    //MARK: SIGN IN PRESSED
    
    @IBAction func signInPressed(_ sender: Any) {
        
        self.startActivityIndicator()
        
        signInButton.isEnabled = false
        
        if checkForBiometric() {
            
            authenticateWithBiometric { (success) in
                
                if success {
                    
                    guard let registration = UserDefaults.standard.string(forKey: "registration") else {
                        return
                    }
//
//                    guard let password = UserDefaults.standard.string(forKey: "password") else {
//                        return
//                    }
                    
                    guard let credentials = Locksmith.loadDataForUserAccount(userAccount: registration) else {
                        return
                    }
                    
                    print(credentials)
                    
                    let password = credentials["password"] as! String
                    print("PASSWORD FROM KEYCHAIN IS \(password)")
                    
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
                    
                } else {
                    
                    print("FACE ID failed to recognize")
                    
                    let banner = NotificationBanner(title: "Snap!", subtitle: "Sorry, we could not recognize you", style: .warning)
                    banner.show()
                    
                    self.stopActivityIndicator()
                    
                    self.signInButton.isEnabled = true
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
                        
                        self.showAlertForSaveCredentials(registration: registration, password: password)
                        
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
            
            
        }
    }

    
    func checkForBiometric() -> Bool {
        
        guard let _ = UserDefaults.standard.string(forKey: "registration") else {
            return false
        }
        
        return true
        
    }
    
    //MARK: VIEW WILL APPEAR
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("login view will appear")
        
        if checkForBiometric() {
            print("biometric is enabled")
            biometricLabel.text = "Face ID is enabled"
            biometricLabel.textColor = .tertiaryLabel
            
        } else {
            print("biometric is disabled")
        }
        
        guard let registration_ = UserDefaults.standard.string(forKey: "registration") else {
            
            registrationFound = false
            passwordFound = false
            
            biometricLabel.text = nil
            registrationTextfield.text = nil
            passwordTextfield.text = nil
            signInButton.isEnabled = false
            
            return
        }
        
        guard let credentials = Locksmith.loadDataForUserAccount(userAccount: registration_) else {
            return
        }
        
        guard let password = credentials["password"] as? String else {
            print("password not found for \(registration_)")
            return
        }
        
        registrationTextfield.text = registration_
        passwordTextfield.text = password
        
        registrationTextfield.isEnabled = false
        passwordTextfield.isEnabled = false
        
    }
    
    var passwordFound = true
    var registrationFound = true
    
    var bottomConstraint: CGFloat = 0.0
    
   
    
    //MARK: LOTTIE ANIMATIONS
    
    func lottieAnimations() {
        
        securityLottieAnimation.play()
    }
    
     //MARK: VIEW DID LOAD
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lottieAnimations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()
        
        
        bottomConstraint = stackViewBottomConstraint.constant
        
        registrationTextfield.delegate = self
        passwordTextfield.delegate = self
        
        registrationTextfield.layer.cornerRadius = 8
        passwordTextfield.layer.cornerRadius = 8
        signInButton.layer.cornerRadius = 8
        
        registrationTextfield.keyboardType = .numberPad
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if checkForBiometric() {
            
            print("biometric is enabled")
            biometricLabel.text = "Face ID is enabled"
            biometricLabel.textColor = .tertiaryLabel
            
        } else {
            
            print("biometric is disabled")
            signInButton.isEnabled = false
            
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
        
        if #available(iOS 13, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                self.navigationController?.navigationBar.barTintColor = .background
                self.view.backgroundColor = .background
                self.tabBarController?.tabBar.barTintColor = .background
                
                securityLottieAnimation.backgroundColor = .background
                signInButton.backgroundColor = .background
                
            } else {
                
                self.navigationController?.navigationBar.barTintColor = .systemOrange
                self.view.backgroundColor = .white
                self.tabBarController?.tabBar.barTintColor = .white
                
                securityLottieAnimation.backgroundColor = .white
                signInButton.backgroundColor = .white
            }
            
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
    
    //MARK: UI ALERT VIEW
    
    func showAlertForInvalidCredentials() {
        
        let invalidAlert = UIAlertController(title: "Invalid credentials", message: "Check your registration/password, and try again", preferredStyle: .alert)
        
        invalidAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            //add code to limit the number of invalid attempts
        }))
        
        let banner = NotificationBanner(title: "Oops!", subtitle: "Ah, here we go again", style: .danger)
        banner.show()
        
        self.present(invalidAlert, animated: true, completion: nil)
        
    }
    
    func showAlertForSaveCredentials(registration: String, password: String) {
        
        let saveLoginAlert = UIAlertController(title: "Remember log in", message: "Your credentials will be stored on your iPhone's Keychain", preferredStyle: .alert)
        
        saveLoginAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            
            let banner = NotificationBanner(title: "Saved!", subtitle: "Like the North, we always remember", style: .success)
            banner.show()
            
            UserDefaults.standard.set(true, forKey: "userSaved")
            
            UserDefaults.standard.set(registration, forKey: "registration")
            
            try! Locksmith.saveData(data: ["registration": registration, "password": password], forUserAccount: registration)
                
            print("Registration and password stored in Locksmith")
            
            
            self.performSegue(withIdentifier: "slcmDetail", sender: self)
            
        }))
        
        saveLoginAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            //add code to limit the number of invalid attempts
            let banner = NotificationBanner(title: "Oh no!", subtitle: "If you change your mind, you can always set this in the settings", style: .danger)
            banner.show()
            
            self.performSegue(withIdentifier: "slcmDetail", sender: self)
        }))
        
        self.present(saveLoginAlert, animated: true, completion: nil)
        
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
        
    }
    
    //MARK: API CALL
    
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
    
    //MARK: ANIMATION
    func animateBottomConstraint(direction: Int) {
        
        if direction == 0 { //down
            
            self.stackViewBottomConstraint.constant = self.bottomConstraint
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            
            self.stackViewBottomConstraint.constant += 90
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    //MARK:- TextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("text field being edited..")
        animateBottomConstraint(direction: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("text field ended editing..")
        print("Text field has text \(textField.text ?? "NA")")
        resignFirstResponder()
        
        if registrationTextfield.text != nil && registrationTextfield.text?.count == 9 && passwordTextfield.text != nil {
            signInButton.isEnabled = true
        }
        
        animateBottomConstraint(direction: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.view.endEditing(true)
        animateBottomConstraint(direction: 0)
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
    
    @IBAction func unwindFromSLCMSettings(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? SLCMSettingsViewController {
            print("Unwinding back to SLCM login")
            
            print("log out pressed")
            
            guard let registration = UserDefaults.standard.string(forKey: "registration") else {
                return
            }
                   
            try! Locksmith.deleteDataForUserAccount(userAccount: registration)
            
            UserDefaults.standard.set(false, forKey: "userSaved")
            UserDefaults.standard.set(nil, forKey: "registration")
            UserDefaults.standard.set(nil, forKey: "password")
            
            biometricLabel.text = nil
            registrationTextfield.text = nil
            passwordTextfield.text = nil
            
            registrationTextfield.isEnabled = true
            passwordTextfield.isEnabled = true
            signInButton.isEnabled = false
            
            let banner = NotificationBanner(title: "Well..", subtitle: "We will not be able to send you notifications about your SLCM updates!", style: .warning)
            banner.show()
        }
    }
    
    //MARK: Bottom Settings View
    func presentBottomSettings() {
        
        guard let settingsController = storyboard?.instantiateViewController(identifier: "slcmSettings") as? SLCMSettingsViewController else {
            return
        }
        
        let sheet = MDCBottomSheetController(contentViewController: settingsController)
        present(sheet, animated: true, completion: nil)
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

