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

import Hero
import NVActivityIndicatorView

class ArticleWebViewController: UIViewController, UINavigationControllerDelegate, WKNavigationDelegate, UIWebViewDelegate {
    
    let API = "https://app.themitpost.com/posts/render/"
    var url: String?
    
    var POST_ID: String?
    var category: String?
    
    var articleMessage: String?
    var articleURL: String?
    var articleAuthor: String?
    var articleTitle: String?

    @IBOutlet weak var articleWebView: WKWebView!
    
    var activityIndicator: NVActivityIndicatorView?
    
    fileprivate let heroTransition = HeroTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        //self.navigationController?.delegate = self
        //self.navigationController?.hero.navigationAnimationType = .selectBy(presenting: .zoomSlide(direction: .left), dismissing: .zoomSlide(direction: .right))
        
        if let category_ = category {
            self.title = String.init(htmlEncodedString: category_)
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            articleWebView.backgroundColor = .background
        } else {
            articleWebView.backgroundColor = .white
        }
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 40, height: 40))
        
        createActivityIndicator()
        
        if let id = POST_ID {
            
            var urlString = API + id
            
            if traitCollection.userInterfaceStyle == .dark {
                self.view.backgroundColor = .background
                articleWebView.backgroundColor = .background
                urlString += "/dark"
            }
            
            let url = URL(string: urlString)!
            
            articleWebView.load(URLRequest(url: url))
            
            
        } else {
            print("Invalid request..")
        }
        
        articleWebView.navigationDelegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: FOR HERO
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        return heroTransition.navigationController(navigationController, interactionControllerFor: animationController)
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return heroTransition.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
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
                
                decisionHandler(.cancel)
                
                //MARK: SHARE ARTICLE
                let shareTitle = "Check out this amazing piece by " + (articleAuthor ?? "") + "!\n\n"
                let shareURL = "\n\nRead the full article at " + (articleURL ?? "www.themitpost.com")
                let shareApp = "\n\nShared from The MIT Post app. Available for both iOS and Android!"
                let shareArticleTitle = "*" + (articleTitle ?? "") + "*\n\n"
                let shareArticleMessage = (articleMessage ?? "") + "\n\n"
                
                let shareItems = [shareTitle, shareArticleTitle, shareArticleMessage, shareURL, shareApp]
                
                let shareActivityController = UIActivityViewController(activityItems: shareItems as [Any], applicationActivities: nil)
                
                   present(shareActivityController, animated: true)
                
            } else if host.contains("app.themitpost.com") {
                print("opening article")
                decisionHandler(.allow)
                
            } else {
                print("disallowing | Opening in Safari")
                decisionHandler(.cancel)
                
                UIApplication.shared.open(navigationAction.request.url!)
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
        
        self.articleWebView.addSubview(activityIndicator!)
        
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
