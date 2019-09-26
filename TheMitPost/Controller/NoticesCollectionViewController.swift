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
    
    //MARK: VIEW WILL DID APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mode()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mode()
        
        noticesCollectionView.delegate = self
        noticesCollectionView.dataSource = self
        
        retrieveNotices()
    }
    
    //MARK: THEME MODE
    
    func mode() {
        
        if #available(iOS 13.0, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                print("dark mode detected")
                self.navigationController?.navigationBar.barTintColor = .background
                self.tabBarController?.tabBar.barTintColor = .background

                self.view.backgroundColor = UIColor.background
                noticesCollectionView.backgroundColor = UIColor.background
                
            } else {
                
                print("light mode detected")
                self.navigationController?.navigationBar.barTintColor = .systemOrange
                self.tabBarController?.tabBar.barTintColor = .white
                
                self.view.backgroundColor = .white
                noticesCollectionView.backgroundColor = .white
                
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
       mode()
    }

    //MARK: API CALL
    
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
            
            print("\(self.notices.count) notices retrieved")
        }
        
    }
    
    //MARK: COLLECTION VIEW DELEGATE
    
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
                print("PDF CELL FOUND")
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
                
                cell.url = notice.getComponentURL
                cell.titleText = notice.title
                cell.contentText = notice.content
                
                cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: NoticeTextCollectionViewCell.width, height: NoticeTextCollectionViewCell.height)
                
                return cell
                
            }
            
        } else {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
            
            cell.titleText = notice.title
            cell.contentText = notice.content
            
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: NoticeTextCollectionViewCell.width, height: NoticeTextCollectionViewCell.height)
            
            cell.isUserInteractionEnabled = false
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30.0, left: 20.0, bottom: 0, right: 20.0)
    }
    
    //MARK: SEGUE
    //MARK: DETAIL IMAGE SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailNotice" {
            
            guard let cellType = sender as? NoticeImageCollectionViewCell else {
                return
            }
            
            if let destinationViewController = segue.destination as? ImagePresentViewController {
                
                let path = self.noticesCollectionView.indexPath(for: cellType)
                
                if let path_ = path {
                    
                    print("URL IS \(String(describing: notices[path_.row].getComponentURL))")
                    destinationViewController.image_url = notices[path_.row].getComponentURL
                }
                
            }
            
        } else if segue.identifier == "pdfViewer" {
            
            guard let cellType = sender as? NoticeTextCollectionViewCell else {
                return
            }
            
            if let destinationViewController = segue.destination as? PDFLoadViewController {
                
                let path = self.noticesCollectionView.indexPath(for: cellType)
                
                if let path_ = path {
                    
                    print("This is PDF")
                    destinationViewController.url = notices[path_.row].getComponentURL
                    
                }
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
