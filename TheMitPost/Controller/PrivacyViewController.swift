//
//  PrivacyViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 05/10/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var topThingView: UIImageView!
    
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let url_ = url {
            webView.load(URLRequest(url: url_))
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
