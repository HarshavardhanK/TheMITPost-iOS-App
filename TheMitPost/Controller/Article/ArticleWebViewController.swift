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

import NVActivityIndicatorView

class ArticleWebViewController: UIViewController, WKNavigationDelegate, UIWebViewDelegate {
    
    let API = "https://app.themitpost.com/posts/render/"
    
    var POST_ID: String?
    var category: String?

    @IBOutlet weak var articleWebView: WKWebView!
    
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category_ = category {
            self.title = category_
        }
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 40, height: 40))
        
        
        
        if let id = POST_ID {
            
            var urlString = API + id
            
            if traitCollection.userInterfaceStyle == .dark {
                self.view.backgroundColor = .background
                articleWebView.backgroundColor = .background
                urlString += "/dark"
            }
            
            let url = URL(string: urlString)!
            
            createActivityIndicator()
            
            articleWebView.load(URLRequest(url: url))
            
            stopActivityIndicator()
            
        } else {
            print("Invalid request..")
        }
        
        articleWebView.navigationDelegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- UI MODE
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
         var urlString = API + POST_ID!
        
        if traitCollection.userInterfaceStyle == .dark {
            
            self.navigationController?.navigationBar.barTintColor = .background
            articleWebView.backgroundColor = .background
            
            if traitCollection.userInterfaceStyle == .dark {
                urlString += "/dark"
            }
            
            let url = URL(string: urlString)!
            
            articleWebView.load(URLRequest(url: url))
            
            articleWebView.addSubview(activityIndicator!)
            createActivityIndicator()
            
        } else {
            
            self.navigationController?.navigationBar.barTintColor = .systemOrange
            
            articleWebView.backgroundColor = .white
            articleWebView.load(URLRequest(url: URL(string: urlString)!))
            
        }
    }
    
    //MARK: Web View API
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let host = navigationAction.request.url?.absoluteString {
            
            if host.contains("share") {
                print("disallowing")
                print("share")
                decisionHandler(.cancel)
                
                //TODO: Share article code goes here
                
               
                
            } else if host.contains("app.themitpost.com") {
                print("opening article")
                decisionHandler(.allow)
                
            } else {
                print("disallowing")
                decisionHandler(.cancel)
            }
        }

        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivityIndicator()
    }
    
   
    //MARK: Loading View Animation
    func createActivityIndicator() {
        
        let types = [NVActivityIndicatorType.ballScaleRippleMultiple, NVActivityIndicatorType.ballBeat, NVActivityIndicatorType.ballScale, NVActivityIndicatorType.ballPulseSync]
        
        let index: Int = Int(arc4random()) % 4
        
        activityIndicator?.type = types[index]
        
        activityIndicator?.color = UIColor.lightGray
        
        self.view.addSubview(activityIndicator!)
        
    }
    
    func stopActivityIndicator() {
        
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        
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
