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
import GoogleSignIn
import FirebaseAuth
import Firebase

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITabBarControllerDelegate {
    
    let API = "https://api.themitpost.com/posts";
    var articlesList = [Article]()
    
    @IBOutlet var articleCollectionView: UICollectionView!
    
    let appBar = MDCAppBar()
    let articleHeaderView = ArticleHeaderView()
    let refreshControl = UIRefreshControl()
    
    let window: UIWindow? = nil
    let _storyboard_ = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    @IBAction func tempLogout(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.signOut()
        try! Auth.auth().signOut()
        
        self.present(_storyboard_.instantiateViewController(withIdentifier: "loginView"), animated: true) {
            print("Successfully logged out and presenting login")
        }
        
    }
    
    var articlesShown = [Bool]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveArticles()
        
        configureAppBar()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //self.tabBarController?.tabBar.isHidden = false
        
        // Do any additional setup after loading the view, typically from a nib.
        print("Bounds of the view W: \(view.bounds.width) H: \(view.bounds.height)")
        print("Frame of the view W: \(view.frame.width) H: \(view.frame.height)")
        
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.addSubview(refreshControl)
        
        tabBarController?.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        
        
        //MARK:- UINavigationBar Appearance
        
    }
    
    //MARK:- FETCH ARTICLES
    
    
    var selectedArticle: Article?
    
    private func retrieveArticles() {
        
        Alamofire.request(API, method: .get).responseJSON { response in
            
            let result = JSON(response.result.value!)
            //print(result.count)
            
            self.parseArticleResult(result: result)
            
            self.articleCollectionView.reloadData()
            self.refreshControl.endRefreshing()
            
            self.articlesShown = [Bool](repeating: false, count: self.articlesList.count)
            
        }
        
        print("Retrieved articles!")
        
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
            
            print(article.message)
            
            articlesList.append(article)
        
        }
        
        for article in self.articlesList {
            print(article.title!)
        }
        
        
    }
    
    @objc func refreshArticles() {
        retrieveArticles()
        articlesShown = [Bool]()
        print("Finished refreshing..")
    }
    
    
    //MARK:- Configue UI
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureAppBar() {
        
        self.addChild(appBar.headerViewController)
        
        //appBar.navigationBar.title = nil
        
        appBar.navigationBar.backgroundColor = .clear
        
        let headerView = appBar.headerViewController.headerView
        headerView.backgroundColor = .clear
        headerView.maximumHeight = ArticleHeaderView.CONSTANTS.maxHeight
        headerView.minimumHeight = ArticleHeaderView.CONSTANTS.minHeight
        
        
        articleHeaderView.frame = headerView.bounds
        headerView.insertSubview(articleHeaderView, at: 0)
        headerView.trackingScrollView = self.articleCollectionView
        
        appBar.addSubviewsToParent()
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            
            self.articleCollectionView.setContentOffset(CGPoint(x: 0, y: -ArticleHeaderView.CONSTANTS.maxHeight), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = appBar.headerViewController.headerView
        
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidScroll()
        }
    }
    
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let headerView = appBar.headerViewController.headerView
        
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
        
    }
    
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let headerView = appBar.headerViewController.headerView
        
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO:- Write code to segue to presentArticleView
        
        /*
         UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YourStoryBoardName" bundle:[NSBundle mainBundle]];
         YourViewControllerFromStoryBoard *viewController = [sb instantiateViewControllerWithIdentifier:@"YourViewControllerIdentifierInYourStoryBoard"];
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "articleViewSegue" {
            print("Going to ArticleTableViewController")
            
            if let destinationViewController = segue.destination as? ArticleTableViewController {
                //destinationViewController.article = selectedArticle
                let selectedCell = sender as? ArticleCollectionViewCell
                let indexPath = self.articleCollectionView.indexPath(for: selectedCell!)
                
                let selectedArticle = articlesList[(indexPath?.row)!]
                
                destinationViewController.article = selectedArticle
                //print("Sending article \(selectedArticle!.title) to articleView..")
            }
        }
    }
    
    
    //MARK:- UICOLLECTIONVIEWDELEGATEFLOWLAYOUT METHODS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.width - (ArticleCollectionViewCell.cellPadding * 2), height: ArticleCollectionViewCell.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: ArticleCollectionViewCell.cellPadding * 1.5, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return ArticleCollectionViewCell.cellPadding * 1.60 // need to trial and test this number to suit all iOS devices (iPhone 5S and upwards). This worked good on iPhone X
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if articlesShown[indexPath.row] == false {
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, -5, 50, -5)
            cell.layer.transform = transform
            cell.alpha = 0.0
            
            
            UIView.animate(withDuration: 0.9, delay: 0.1, options: [.curveEaseOut, .allowUserInteraction], animations: {
                
                // transform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 2)
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
                
            }) { (true) in
                print("Animation complete")
                
            }
            
            articlesShown[indexPath.row] = true
            
        }
        
    }
    
    //MARK:- UICOLLECTIONVIEWDATASOURCE DELEGATE METHODS
    
    //MARK:- UNWIND SEGUES
    @IBAction func unwindToArticlesListFromArticle(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? ArticleViewController {
            print("Unwinding back to articles list")
        }
    }
    
    @IBAction func unwindToArticlesListFromSLCM(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? SLCMLoginViewController {
            print("Unwinding back to articles list")
        }
    }


}

