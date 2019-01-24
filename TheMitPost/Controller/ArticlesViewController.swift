//
//  FirstViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 14/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import SDWebImage

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet var articleCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Bounds of the view W: \(view.bounds.width) H: \(view.bounds.height)")
        print("Frame of the view W: \(view.frame.width) H: \(view.frame.height)")
        
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self

        retrieveArticles()
        
    }
    
    //MARK:- FETCH ARTICLES
    
    var articlesList = [Article]()
    
    private func retrieveArticles() {
        
        let articlesRef = Database.database().reference(withPath: "articles")
        let structuredRef = articlesRef.child("structured")
        
       structuredRef.observe(.value, with: { (snapshot) in
        
        if let data = snapshot.value {
            
            let articles = JSON(data)
                
            for (key, _) in articles {
                    
                let articleJSON = articles[key]
                
                let articleID = articleJSON["id"].intValue
                let articleTitle = articleJSON["title"].stringValue
                let articleDate = articleJSON["date"].stringValue
                
                let articleContent = articleJSON["content"].arrayObject as? Array<String>
                let articleImages = articleJSON["imageURLs"].arrayObject as? Array<String>
                
                let newArticle = Article(articleID: articleID, title: articleTitle, date: articleDate, content: articleContent!, imageURLS: articleImages!)
                
                self.articlesList.append(newArticle)
                
                print(self.articlesList[0].content!)
                    
            }
                
            } else {
                print("No value being retrieved")
            }
        
       });
        
    }
    
    //MARK:- UI CONFIGURATION
    
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
    


}

