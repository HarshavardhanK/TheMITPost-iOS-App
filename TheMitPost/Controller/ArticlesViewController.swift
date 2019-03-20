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
    
    let API = "https://api.themitpost.com/posts";
    var articlesList = [Article]()
    
    @IBOutlet var articleCollectionView: UICollectionView!
    
    let appBar = MDCAppBar()
    let articleHeaderView = ArticleHeaderView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        retrieveArticles()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppBar()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        print("Bounds of the view W: \(view.bounds.width) H: \(view.bounds.height)")
        print("Frame of the view W: \(view.frame.width) H: \(view.frame.height)")
        
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        
        tabBarController?.delegate = self
        
        
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
        
        print(tabBarIndex)
        
        if tabBarIndex == 0 {
            self.articleCollectionView.setContentOffset(CGPoint.zero, animated: true)
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
            print("Going to articeView")
            
            if let destinationViewController = segue.destination as? ArticleViewController {
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

        return UIEdgeInsets(top: ArticleCollectionViewCell.cellPadding, left: ArticleCollectionViewCell.cellPadding, bottom: ArticleCollectionViewCell.cellPadding, right: ArticleCollectionViewCell.cellPadding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return ArticleCollectionViewCell.cellPadding * 1.60 // need to trial and test this number to suit all iOS devices (iPhone 5S and upwards). This worked good on iPhone X
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    //MARK:- UICOLLECTIONVIEWDATASOURCE DELEGATE METHODS
    
    //MARK:- UNWIND SEGUES
    @IBAction func unwindToArticlesListFromArticle(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? ArticleViewController {
            print("Unwinding back to articles list")
        }
    }
    
    @IBAction func unwindToArticlesListFromSLCM(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? SLCMViewController {
            print("Unwinding back to articles list")
        }
    }


}

