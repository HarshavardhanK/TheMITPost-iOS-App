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

    @IBAction func skipSignIn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sign In Alert", message: "Unless you've signed in, our SLCM engine will not be able to send you detailed notifications when your data is updated by faculty", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay, continue", style: .default, handler: {action in
            
            let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "tabView"))!
            self.present(nextViewController, animated:true, completion:nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {action in
            print("Google Sign in")
            
        }))
            
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        
        
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
