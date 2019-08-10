//
//  SignInViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 26/07/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class SignInViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        if Auth.auth().currentUser != nil {
            
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "tabView"))!, animated: true, completion: {
                print("Logged in")
            })
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
