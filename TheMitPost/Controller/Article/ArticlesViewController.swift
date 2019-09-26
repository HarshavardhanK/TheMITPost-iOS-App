//
//  FirstViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 14/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import MaterialComponents.MaterialAppBar
import SDWebImage


class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITabBarControllerDelegate {
    
    let API = "https://app.themitpost.com/posts";
    var articlesList = [Article]()
    
    @IBOutlet var articleCollectionView: UICollectionView!
    
    //let refreshControl = UIRefreshControl()
    
    let window: UIWindow? = nil
    let _storyboard_ = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    @IBOutlet weak var logoutSigninBarButton: UIBarButtonItem!
    
    
    var articlesShown = [Bool]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()
    
        retrieveArticles { (success) in
            
            if !success {
                
                let emptyImageView = UIImageView(image: UIImage(named: "post-empty"))
                emptyImageView.frame = CGRect(origin: self.view.center, size: CGSize(width: 300, height: 237))
                emptyImageView.center = self.view.center
                
                self.view.addSubview(emptyImageView)
            }
            
        }
        
        //configureAppBar()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //self.tabBarController?.tabBar.isHidden = false
        
        // Do any additional setup after loading the view, typically from a nib.
        print("Bounds of the view W: \(view.bounds.width) H: \(view.bounds.height)")
        print("Frame of the view W: \(view.frame.width) H: \(view.frame.height)")
        
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        //articleCollectionView.addSubview(refreshControl)
        
        tabBarController?.delegate = self
        
       // refreshControl.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        
        
    }
    
    //MARK:- FETCH ARTICLES
    
    
    var selectedArticle: Article?
    
    private func retrieveArticles(completion: @escaping (Bool) -> ()) {
        
        Alamofire.request(API, method: .get).responseJSON { response_ in
            
            guard let resultValue = response_.result.value else {
                completion(false)
                return
            }
            //print(result.count)
            
            self.parseArticleResult(result: JSON(resultValue))
            
            self.articleCollectionView.reloadData()
            //self.refreshControl.endRefreshing()
            
            self.articlesShown = [Bool](repeating: false, count: self.articlesList.count)
            
            print("Retrieved articles!")
            
            if(self.articlesList.count == 0) {
                completion(false)
                
            } else {
                completion(true)
            }
            
        }
        
    }
    
    private func parseArticleResult(result: JSON) {
        
        print(result.count)
        
        for i in 0...result.count {
            
            let data = result[i]
            
            let year = data["date"]["year"].stringValue
            let month = data["date"]["month"].stringValue
            let day = data["date"]["day"].stringValue
            
            let date = day + " " + month + " " + year
            
            let article = Article(articleID: data["_id"].stringValue, title: String(htmlEncodedString: data["title"].stringValue)!,author: data["author"]["name"].stringValue, date: date, featured_media: data["featured_media"].stringValue, message: data["message"].stringValue, content: nil)
            
            
            articlesList.append(article)
        
        }
        
        
    }
    
    @objc func refreshArticles() {
        articlesList = [Article]()
        
        retrieveArticles{ (sucess) in
            
            if(sucess) {
            
                self.articlesShown = [Bool](repeating: false, count: self.articlesList.count)
                print("Finished refreshing..")
                
            }
        }
        
    }
    
    
    //MARK:- Configue UI
    /*override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }*/
    
    func mode() {
        
        if #available(iOS 13.0, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                print("dark mode detected")
                self.navigationController?.navigationBar.barTintColor = .background
                self.tabBarController?.tabBar.barTintColor = .background

                self.view.backgroundColor = .background
                articleCollectionView.backgroundColor = .background
                
            } else {
                
                print("light mode detected")
                self.navigationController?.navigationBar.barTintColor = .systemOrange
                self.tabBarController?.tabBar.barTintColor = .white
                
                self.view.backgroundColor = .white
                articleCollectionView.backgroundColor = .white
                
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
       mode()
    }

    
    //MARK:- UICOLLECTIONVIEW DATASOURCE AND DELEGATE METHODS
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let articleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? ArticleCollectionViewCell {
            
            articleCell.article = articlesList[indexPath.row]
            
            return articleCell
            
        } else {
            fatalError("Missing cell for indexPath: \(indexPath)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "articleViewSegue" {
            print("Going to ArticleTableViewController")
            
            if let destinationViewController = segue.destination as? ArticleWebViewController {
                //destinationViewController.article = selectedArticle
                let selectedCell = sender as? ArticleCollectionViewCell
                let indexPath = self.articleCollectionView.indexPath(for: selectedCell!)
                
                let selectedArticle = articlesList[(indexPath?.row)!]
                
                destinationViewController.POST_ID = selectedArticle.articleID
                //print("Sending article \(selectedArticle!.title) to articleView..")
            }
        }
    }
    
    
    //MARK:- UICOLLECTIONVIEWDELEGATEFLOWLAYOUT METHODS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.width - (ArticleCollectionViewCell.cellPadding * 2), height: ArticleCollectionViewCell.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: ArticleCollectionViewCell.cellPadding + 15, left: 30.0, bottom: 30.0, right: 30.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return ArticleCollectionViewCell.cellPadding + 10  // need to trial and test this number to suit all iOS devices (iPhone 5S and upwards). This worked good on iPhone X
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if articlesShown[indexPath.row] == false {
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, -5, 50, -5)
            cell.layer.transform = transform
            cell.alpha = 0.0
            
            
            UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseOut, .allowUserInteraction], animations: {
                
                // transform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 2)
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
                
            }) { (true) in
                print("Animation complete")
                
            }
            
            articlesShown[indexPath.row] = true
            
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.articleCollectionView.setContentOffset(CGPoint.zero, animated: true)
        }
        
    }
    
    //MARK:- UICOLLECTIONVIEWDATASOURCE DELEGATE METHODS
    
    //MARK:- UNWIND SEGUES
    @IBAction func unwindToArticlesListFromArticle(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? ArticlesViewController {
            print("Unwinding back to articles list")
        }
    }
    
    @IBAction func unwindToArticlesListFromSLCM(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? SLCMLoginViewController {
            print("Unwinding back to articles list")
        }
    }


}

