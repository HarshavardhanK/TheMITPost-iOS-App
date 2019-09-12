//
//  NoticeViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 12/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NoticeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let API = "https://api.themitpost.com/notices"
    
    var notices = [Notice]()

    @IBOutlet weak var noticeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("waa")

        // Do any additional setup after loading the view.
        noticeCollectionView.delegate = self
        noticeCollectionView.dataSource = self
        
        
        retrieveNotices()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 300)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("ehh")
        
        let notice = notices[indexPath.row]
        
        if(notice.hasURL) {
            
            print("has url")
            
            if(notice.isImage) {
                
                print("image notice")
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! NoticeImageCollectionViewCell
                
                cell.imageURL = notices[indexPath.row].getComponentURL!
                cell.text = notices[indexPath.row].title!
                
               // cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: self.view.frame.width, height: 350.0)
                
                return cell
                
            } else {
                
                //TODO PDF CELL
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pdfCell", for: indexPath) as! NoticePDFCollectionViewCell
                
                return cell
            }
            
        } else {
            
            print("no url")
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
            
            cell.text = notices[indexPath.row].title!
            
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: self.view.frame.width, height: 80)
            
            return cell
            
        }
        
    }
    
    func retrieveNotices() {
        
        Alamofire.request(API, method: .get).responseJSON {
            response_ in
            
            let response = JSON(response_.result.value!)
            
            if(response["status"] != "OK") {
                print("BAD REQUEST FOR NOTICE")
                return
                
            } else {
                
                let data = response["data"].arrayValue
                
                self.notices = parseNotices(data: data)
                
                print("Notices collected")
                
                self.noticeCollectionView.reloadData()
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
