//
//  NoticesCollectionViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 18/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NoticesCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let API = "https://app.themitpost.com/notices"
    
    @IBOutlet weak var noticesCollectionView: UICollectionView!
    
    var notices = [Notice]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if traitCollection.userInterfaceStyle == .dark {
            self.navigationController?.navigationBar.barTintColor = .black
        }
        
        if #available(iOS 13, *) {
            noticesCollectionView.backgroundColor = .systemBackground
            self.view.backgroundColor = .systemBackground
            
        }
        
        noticesCollectionView.delegate = self
        noticesCollectionView.dataSource = self
        
        retrieveNotices()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let style = traitCollection.userInterfaceStyle
        
        if style == .dark {
            print("dark mode detected")
            self.navigationController?.navigationBar.barTintColor = .black
        }
        
        if style == .light {
            print("light mode detected")
            self.navigationController?.navigationBar.barTintColor = .systemOrange
        }
    }
    
    func retrieveNotices() {
        
        Alamofire.request(API, method: .get).responseJSON {
            response_ in
            
            let response = JSON(response_.result.value!)
            
            if response["status"] != "OK" {
                print("error")
                
            } else {
                
                let data = response["data"].arrayValue
                
                self.notices = parseNotices(data: data)
                
                self.noticesCollectionView.reloadData()
                
                print("Successfully loaded data")
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let notice = notices[indexPath.row]
        
        if(notice.hasURL) {
            
            print("has url")
            
            if(notice.isImage) {
                
                print("image notice")
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! NoticeImageCollectionViewCell
                
                cell.url = notice.getComponentURL
                cell.titleText = notice.title
                cell.contentText = notice.content
                
                cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: NoticeImageCollectionViewCell.width, height: NoticeImageCollectionViewCell.height)
                
                return cell
                
            } else {
                
                //TODO PDF CELL
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pdfCell", for: indexPath) as! NoticeImageCollectionViewCell
                
                return cell
                
            }
            
        } else {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
            
            cell.titleText = notice.title
            cell.contentText = notice.content
            
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: NoticeTextCollectionViewCell.width, height: NoticeTextCollectionViewCell.height)
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30.0, left: 20.0, bottom: 5.0, right: 20.0)
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
