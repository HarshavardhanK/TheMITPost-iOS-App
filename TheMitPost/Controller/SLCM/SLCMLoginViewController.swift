//
//  SecondViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 14/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import LocalAuthentication
import NotificationCenter

import OnboardKit
import Alamofire
import SwiftyJSON
import Lottie
import NotificationBannerSwift
import NVActivityIndicatorView
import Locksmith
import MaterialComponents

class SLCMLoginViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UNUserNotificationCenterDelegate , NVActivityIndicatorViewable {
    
    let notificationCenter = NotificationCenter.default
    
    let SLCMAPI: String = "https://app.themitpost.com/values"
    let FCMTokenAPI: String = "https://app.themitpost.com/credential"
    
    @IBOutlet weak var registrationTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var biometricLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var stackViewHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var securityLottieAnimation: AnimationView!
    
    @IBAction func logoutAction(_ sender: Any) {
        
        presentBottomSettings()
    }
    
    
    var subjects = [Subject]()
    
    var result = false
    
    var count: Int = 0 // counting invalid attempts
    
    let context = LAContext()
    
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
    
    enum BIOMETRY_TYPE: Int {
        case success = 1
        case notRecognized = 2
        case notEnabled = 0
    }
    
    func authenticateWithBiometric(completion: @escaping (BIOMETRY_TYPE) -> ())  {
        
        print("Authenticating")
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "slcm login"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                
                 success, authenticationError in
                
                if success {
                    
                    DispatchQueue.main.async { [unowned self] in
                        print("Successfully authenticated")
                        completion(.success)
                    }
                    
                } else {
                    //invalid authentication error
                    print("Could not authenticate")
                    completion(.notRecognized)
                }
                
            }
            
        } else {
            print("Couldnt find biometry")
            // no biometry
            completion(.notEnabled)
            
        }
        
        
    }
    
    //MARK: SIGN IN PRESSED
    
    @IBAction func signInPressed(_ sender: Any) {
        
        registrationTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        
        self.startActivityIndicator()
        
        signInButton.isEnabled = false
        
        if checkForBiometric() && isUserSaved() {
            print("Signing in with biometry")
            
            authenticateWithBiometric { (response) in
                
                if response == .success {
                    
                    if self.isUserSaved() {
                        print("User saved")
                        self.signIn_Saved()
                        
                    }
                    
                } else if response == .notRecognized {
                    self.signIn_biometryFailed()
                    
                } else {
                    
                    let banner = NotificationBanner(title: "Oops!", subtitle: "Please enable " + self.biometricType() + " in settings", style: .warning)
                    banner.show()
                }
            }
            
        } else {
            
            print("Biometry sign in disabled")
            
            if isUserSaved() {
                
                print("User saved")
                self.signIn_Saved()
                
            } else {
                
                print("User not saved")
                self.signIn_NotSaved()
                
            }
        }
    }
    
    var passwordFound = true
    var registrationFound = true
    
    var bottomConstraint: CGFloat = 0.0
    var topConstraint: CGFloat = 0.0
    
    
    //MARK: LOTTIE ANIMATIONS
    
    func lottieAnimations() {
        
        securityLottieAnimation.play()
    }
    
    //MARK: VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isUserSaved() {
            
            if let regText = UserDefaults.standard.string(forKey: DEFAULTS.REGISTRATION) {
                registrationTextfield.text = regText
                
                guard let credentials = Locksmith.loadDataForUserAccount(userAccount: regText) else {
                    return
                }
                
                signInButton.isEnabled = true
                
                passwordTextfield.text = credentials["password"] as? String
                
            } else {
                signInButton.isEnabled = false
            }
        }
        
    }
    
    //MARK: Onboarding
    lazy var onboardingPages: [OnboardPage] = {
        
        let pageOne = OnboardPage(title: "Welcome to SLCM",
                                  imageName: "rocket",
                                  description: "The Post SLCM is an easy to use, fast and secure SLCM utility", advanceButtonTitle: "Great!")
        
        let pageTwo = OnboardPage(title: "Security",
                                  imageName: "lock",
                                  description: "We use state of the art security practices to ensure that only you have control of your data. By continuing further, you agree to our privacy policy",
                                  advanceButtonTitle: "I agree",
                                  actionButtonTitle: "Enable " + biometricType(),
                                  action: { [weak self] completion in
                                    
                                    UserDefaults.standard.set(true, forKey: DEFAULTS.BIOMETRIC_ENABLED)
                                    let banner = NotificationBanner(title: "Great!", subtitle: "You have enabled " + (self?.biometricType())! + " for fast login", style: .success)
                                    banner.show()
                                    
        })
        
        var pageThree: OnboardPage
        
        let isRegisteredForNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        
        if isRegisteredForNotifications {
            
            pageThree = OnboardPage(title: "Stay up to date",
                                    imageName: "notification",
                                    description: "We send push notifications when your attendance and marks are uploaded so you don't miss a thing!", advanceButtonTitle: "Done")
            
        } else {
            
            pageThree = OnboardPage(title: "Stay up to date",
                                    imageName: "notification",
                                    description: "We send push notifications when your attendance and marks are uploaded so you don't miss a thing!", advanceButtonTitle: "Done",
                                    actionButtonTitle: "Enable Notifications",
                                    action: { [weak self] completion in
                                        
                                        print("Enable notifications tapped")
                                        
                                        if #available(iOS 10.0, *) {
                                            // For iOS 10 display notification (sent via APNS)
                                            UNUserNotificationCenter.current().delegate = self
                                            
                                            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                                            
                                            UNUserNotificationCenter.current().requestAuthorization (
                                                
                                                options: authOptions,
                                                completionHandler: {granted, error in
                                                    
                                                    if granted {
                                                        print("Successfully granted notification permission")
                                                        
                                                    } else {
                                                        print("Notification permission denied")
                                                    }
                                            })
                                            
                                        } else {
                                            
                                            let settings: UIUserNotificationSettings =
                                                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                                            UIApplication.shared.registerUserNotificationSettings(settings)
                                        }
                                        
                                        UIApplication.shared.registerForRemoteNotifications()
            })
            
        }
        
        
        
        
        
        return [pageOne, pageTwo, pageThree]
        
    }()
    
    func onboard() {
        
        var backgroundColor: UIColor
        var labelColor: UIColor
        
        if #available(iOS 13, *) {
            
            labelColor = .secondaryLabel
            
            if traitCollection.userInterfaceStyle == .dark {
                backgroundColor = .background
                
                
            } else {
                backgroundColor = .white
                
            }
            
        } else {
            labelColor = .darkGray
            backgroundColor = .white
        }
        
        let tintColor: UIColor = .systemBlue
        let titleColor = UIColor(red: 1.00, green: 0.35, blue: 0.43, alpha: 1.00)
        let boldTitleFont = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        let mediumTextFont = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        let appearanceConfiguration = OnboardViewController.AppearanceConfiguration(tintColor: tintColor,
                                                                                    titleColor: titleColor,
                                                                                    textColor: labelColor,
                                                                                    backgroundColor: backgroundColor,
                                                                                    titleFont: boldTitleFont,
                                                                                    textFont: mediumTextFont)
        
        let onboardingVC = OnboardViewController(pageItems: onboardingPages, appearanceConfiguration: appearanceConfiguration ,completion: {
            print("onboarding complete")
            
            let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
            
            if !isRegisteredForRemoteNotifications {
                
                let banner = NotificationBanner(title: "Ugh!", subtitle: "Please enable push notifications for the best SLCM experience", style: .warning)
                banner.show()
                
            }
            
        })
        
        onboardingVC.modalPresentationStyle = .formSheet
        onboardingVC.presentFrom(self, animated: true)
        
    }
    
    //MARK: VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "firstTime") == false {
            onboard()
            UserDefaults.standard.set(true, forKey: "firstTime")
        }
        
        mode()
        
        notificationCenter.addObserver(self, selector: #selector(requestForNotification), name: NSNotification.Name("notificationRequest"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(fcmTokenChange), name: NSNotification.Name("FCMTokenChange"), object: nil)
        
        stackView.autoresizingMask = .flexibleBottomMargin
        stackView.autoresizingMask = .flexibleTopMargin
        stackView.autoresizingMask = .flexibleLeftMargin
        stackView.autoresizingMask = .flexibleRightMargin
        
        lottieAnimations()
        
        bottomConstraint = stackViewHorizontalConstraint.constant
        
        registrationTextfield.delegate = self
        passwordTextfield.delegate = self
        
        registrationTextfield.layer.cornerRadius = 8
        passwordTextfield.layer.cornerRadius = 8
        signInButton.layer.cornerRadius = 8
        
        registrationTextfield.keyboardType = .numberPad
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if checkForBiometric() {
            
            biometricLabel.text = biometricType() + " enabled"
            
            if #available(iOS 13, *) {
                biometricLabel.textColor = .tertiaryLabel
            }
            
        } else {
            
            print("biometric is disabled")
            biometricLabel.text = nil
            
        }
        
        if isUserSaved() {
            
            registrationTextfield.text = getRegistration()
            passwordTextfield.text = getPassword()
            
            registrationFound = true
            passwordFound = true
            
            
            registrationTextfield.isEnabled = false
            passwordTextfield.isEnabled = false
            
        } else {
            signInButton.isEnabled = false
            
        }
        
        
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
        
        let banner = NotificationBanner(title: "Oops!", subtitle: "We could not recognize you", style: .danger)
        banner.show()
        
        self.present(invalidAlert, animated: true, completion: nil)
        
    }
    
    func showAlertForSaveCredentials(registration: String, password: String) {
        
        let saveLoginAlert = UIAlertController(title: "Remember log in", message: "Your credentials will be stored on your iPhone's Keychain", preferredStyle: .alert)
        
        saveLoginAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            
            let banner = NotificationBanner(title: "Saved!", style: .success)
            banner.show()
            
            self.fcmAction(registration: registration, password: password, action: "insert")
            
            UserDefaults.standard.set(true, forKey: "userSaved")
            
            UserDefaults.standard.set(registration, forKey: "registration")
            
            print("Crashing here")
            
            if let _ = Locksmith.loadDataForUserAccount(userAccount: registration) {
                print("Existing user found")
                
            } else {
                try! Locksmith.saveData(data: ["registration": registration, "password": password], forUserAccount: registration)
            }
            
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
    enum CALLBACK: String {
        case login = "login"
        case connection = "connection"
        case success = "success"
    }
    
    func loadSLCMData(registration: String, password: String, completion: @escaping (CALLBACK) -> ()) {
        
        print("registration is \(registration)")
        print("password is \(password)")
        
        Alamofire.request(self.SLCMAPI, method: .post, parameters:["regNumber":registration, "pass":password], encoding: JSONEncoding.default).responseJSON { response in
            
            print("calling post request")
            
            guard let resultValue = response.result.value else {
                print("Failing in website")
                
                completion(.connection)
                
                return
            }
            
            let data = JSON(resultValue)
            
            if data["message"].stringValue == "Invalid Credentials" {
                
                print(data["message"].stringValue)
                print("Actually invalid")
                
                completion(.login)
                
            } else {
                
                print("Credentials are right..")
                
                guard let _subjects = groupData(data: data["academicDetails"][0]) else {
                    print("Failing to group")
                    return
                }
                
                print(self.subjects.count)
                
                _subjects[0].display()
                
                self.subjects = _subjects
                
            }
            
            print("Completed POST request")
            
            completion(.success)
            
        }
        
    }
    
    enum ACTIONS: String {
        
        case INSERT = "insert"
        case DELETE = "delete"
        case UPDATE = "update"
        
    }
    
    func fcmAction(registration: String, password: String, action: String) {
        
        if let fcmToken = UserDefaults.standard.string(forKey: "token") {
            
            print("FCM \(fcmToken)")
            
            Alamofire.request(FCMTokenAPI, method: .post, parameters:["regNumber":registration, "pass":password, "fcm_token": fcmToken, "action": action], encoding: JSONEncoding.default).responseJSON { response in
                
                
                print("calling fcm post request")
                
                guard let resultValue = response.result.value else {
                    print("Failing in website")
                    
                    
                    //sendinf false would mean invalid login. Change it
                    //code to send error alert
                    return
                }
                
                let data = JSON(resultValue)
                //print(data)
                
                if data["message"].stringValue == "OK" {
                    print("Sucessfully \(action)ed")
                    
                } else {
                    print("Failed to \(action) token")
                }
                
            }
            
        } else {
            print("NO FCM TOKEN")
        }
        
    }
    
    //MARK: Notifications
    
    @objc func requestForNotification() {
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization (
            
            options: authOptions,
            completionHandler: {granted, error in
                
                if granted {
                    
                    print("Successfully granted notification permission")
                    
                } else {
                    
                    print("Notification permission denied")
                }
        })
    }
    
    @objc func fcmTokenChange() {
        
        if isUserSaved() {
            
            guard let registration = getRegistration() else {
                return
            }
            
            guard let password = getPassword() else {
                return
            }
            
            fcmAction(registration: registration, password: password, action: "update")
            
        }
        
    }
    
    //MARK: ANIMATION
    func animateBottomConstraint(direction: Int) {
        
        if direction == 0 { //down
            
            self.stackViewHorizontalConstraint.constant = self.bottomConstraint
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            
            self.stackViewHorizontalConstraint.constant -= 90
            
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
            
            
        } else if segue.identifier == "settingsSegue" {
            
            let settingsController = segue.destination as! SLCMSettingsViewController
            settingsController.biometricLabel = biometricLabel
            
            let sheet = MDCBottomSheetController(contentViewController: settingsController)
            present(sheet, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func unwindFromSLCMSettings(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? SLCMSettingsViewController {
            print("Unwinding back to SLCM login")
            
            print("log out pressed")
            
            guard let registration = UserDefaults.standard.string(forKey: "registration") else {
                return
            }
            
            if let password = getPassword() {
                fcmAction(registration: registration, password: password, action: "delete")
            }
            
            try! Locksmith.deleteDataForUserAccount(userAccount: registration)
            
            clearUserCache()
            
            let banner = NotificationBanner(title: "Well..", subtitle: "We will not be able to send you notifications about your SLCM updates!", style: .danger)
            banner.show()
            
            UserDefaults.standard.set(false, forKey: "notFirstTime")
            
            
        }
    }
    
    //MARK: Bottom Settings View
    
    func presentBottomSettings() {
        
        if #available(iOS 13.0, *) {
            
            guard let settingsController = storyboard?.instantiateViewController(identifier: "slcmSettings") as? SLCMSettingsViewController else {
                return
            }
            
            settingsController.biometricLabel = biometricLabel
            
            let sheet = MDCBottomSheetController(contentViewController: settingsController)
            sheet.preferredContentSize = CGSize(width: self.view.frame.width, height: 400.0)
            present(sheet, animated: true, completion: nil)
            
            
        } else {
            
            guard let settingsController = storyboard?.instantiateViewController(withIdentifier: "slcmSettings") as? SLCMSettingsViewController else {
                return
            }
            
            settingsController.biometricLabel = biometricLabel
            
            let sheet = MDCBottomSheetController(contentViewController: settingsController)
            sheet.preferredContentSize = CGSize(width: self.view.frame.width, height: 400.0)
            present(sheet, animated: true, completion: nil)
            
        }
        
    }
    
    func clearUserCache() {
        
        UserDefaults.standard.set(nil, forKey: DEFAULTS.REGISTRATION)
        UserDefaults.standard.set(false, forKey: DEFAULTS.BIOMETRIC_ENABLED)
        
        biometricLabel.text = nil
        registrationTextfield.text = nil
        passwordTextfield.text = nil
        
        registrationTextfield.isEnabled = true
        passwordTextfield.isEnabled = true
        signInButton.isEnabled = false
        
        if let registration = UserDefaults.standard.string(forKey: DEFAULTS.REGISTRATION) {
            try! Locksmith.deleteDataForUserAccount(userAccount: registration)
        }
        
    }
    
    //MARK: SIGN IN FUNCTIONS
    
    func signIn_biometryFailed() {
        
        let banner = NotificationBanner(title: "Snap!", subtitle: "Sorry, we could not recognize you", style: .warning)
        banner.show()
        
        let banner2 = NotificationBanner(title: "Check " + biometricType(), subtitle: "The app does not have access to " + biometricType(), style: .warning)
        banner2.show(bannerPosition: .bottom)
        
        self.stopActivityIndicator()
        
        self.signInButton.isEnabled = true
        
    }
    
    @objc func signIn_Saved() {
        
        print("Signing in saved")
        
        if let savedRegistration = UserDefaults.standard.string(forKey: "registration") {
            
            guard let credentials = Locksmith.loadDataForUserAccount(userAccount: savedRegistration) else {
                return
            }
            
            print(credentials)
            
            let password = credentials["password"] as! String
            
            loadSLCMData(registration: savedRegistration, password: password) { (result) in
                
                if result == .success {
                    
                    self.stopActivityIndicator()
                    self.performSegue(withIdentifier: "slcmDetail", sender: self)
                    
                } else if result == .login {
                    
                    self.stopActivityIndicator()
                    self.showAlertForInvalidCredentials()
                    
                } else {
                    
                    self.stopActivityIndicator()
                    
                    let banner = StatusBarNotificationBanner(title: "The Internet connection appears to be offline", style: .danger)
                    banner.haptic = .heavy
                    banner.show()
                }
            }
            
            signInButton.isEnabled = true
            
        }
        
    }
    
    func signIn_NotSaved() {
        
        guard let registration = registrationTextfield.text else {
            return
        }
        
        guard let password = passwordTextfield.text else {
            return
        }
        
        self.passwordTextfield.text = nil
        self.registrationTextfield.text = nil
        
        loadSLCMData (registration: registration, password: password) { (result) in
            
            if result == .success {
                
                self.stopActivityIndicator()
                
                print("Storing \(registration)")
                print("Storing \(password)")
                
                self.showAlertForSaveCredentials(registration: registration, password: password)
                
            } else if result == .login {
                
                self.showAlertForInvalidCredentials()
                
                self.count += 1
                
                UserDefaults.standard.set(self.count, forKey: ERROR_CODES.INVALID_ATTEMPT)
                
                self.stopActivityIndicator()
                
                //            if self.count == 2 {
                //                UserDefaults.standard.set(Date(), forKey: ERROR_CODES.TIME_OF_INVALID)
                //            }
                
            } else {
                
                self.stopActivityIndicator()
                
                let banner = StatusBarNotificationBanner(title: "The Internet connection appears to be offline", style: .danger)
                banner.haptic = .heavy
                banner.show()
                
            }
            
            self.signInButton.isEnabled = true
            
        }
        
    }
    
    
    func checkForBiometric() -> Bool {
        return UserDefaults.standard.bool(forKey: DEFAULTS.BIOMETRIC_ENABLED)
    }
    
    func isUserSaved() -> Bool {
        
        guard let _ = UserDefaults.standard.string(forKey: DEFAULTS.REGISTRATION) else {
            print("No user found")
            return false
        }
        
        print("User found")
        return true
    }
    
    func getRegistration() -> String? {
        
        if let regText = UserDefaults.standard.string(forKey: DEFAULTS.REGISTRATION) {
            return regText
        }
        
        return nil
    }
    
    func getPassword() -> String? {
        
        if let regText = UserDefaults.standard.string(forKey: DEFAULTS.REGISTRATION) {
            
            guard let credentials = Locksmith.loadDataForUserAccount(userAccount: regText) else {
                return nil
            }
            
            return credentials["password"] as? String
        }
        
        return nil
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

