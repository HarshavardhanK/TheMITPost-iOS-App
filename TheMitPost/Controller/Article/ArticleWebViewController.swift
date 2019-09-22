//
//  ArticleWebViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 12/08/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    let API = "https://app.themitpost.com/posts/render/"
    var POST_ID: String?

    @IBOutlet weak var articleWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = POST_ID {
            
            var urlString = API + id
            
            if traitCollection.userInterfaceStyle == .dark {
                urlString += "/dark"
            }
            
            let url = URL(string: urlString)!
            
            articleWebView.load(URLRequest(url: url))
            
        } else {
            print("Invalid request..")
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
         var urlString = API + POST_ID!
        
        if traitCollection.userInterfaceStyle == .dark {
            
            self.navigationController?.navigationBar.barTintColor = .darkGray
            
            if traitCollection.userInterfaceStyle == .dark {
                urlString += "/dark"
            }
            
            let url = URL(string: urlString)!
            
            articleWebView.load(URLRequest(url: url))
            
        } else {
            self.navigationController?.navigationBar.barTintColor = .systemOrange
            articleWebView.load(URLRequest(url: URL(string: urlString)!))
            
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("navigation function")
        
        if let url = navigationAction.request.url {
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                
            }
            
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
