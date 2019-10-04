//
//  NoticesCollectionViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 18/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

import Lottie
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

class NoticesCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let API = "https://app.themitpost.com/notices"
    
    @IBOutlet weak var noticesCollectionView: UICollectionView!
    
    var notices = [Notice]()
    let refreshControl = UIRefreshControl()
    
    //MARK: VIEW WILL DID APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mode()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mode()
        startActivityIndicator()
        retrieveNotices()
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: NoticeImageCollectionViewCell.width, height: 120.0)
        
       // noticesCollectionView.collectionViewLayout = layout
        noticesCollectionView.delegate = self
        noticesCollectionView.dataSource = self
        
        noticesCollectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refreshNotices), for: .valueChanged)
        
    }
    
    //MARK: ACTIVITY INDICATOR VIEW
    var activityIndicator: NVActivityIndicatorView!
    func startActivityIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 50, height: 50), type: .ballRotateChase, color: .lightGray, padding: 0)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    //MARK: EMPTY LOTTIE VIEW
    func createEmptyView() {
        
        let emptyImageView = AnimationView(name: "empty-box")
        emptyImageView.frame = CGRect(origin: self.view.center, size: CGSize(width: 300, height: 237))
        emptyImageView.center = self.view.center
        
        self.view.addSubview(emptyImageView)
        emptyImageView.play()
        
        let label = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.height / 2 + 200, width: 200, height: 30))
        label.text = "Pull to refresh"
        self.view.addSubview(label)
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
            
        } else {
            self.navigationController?.navigationBar.barTintColor = .white
            self.tabBarController?.tabBar.barTintColor = .white
            
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
            
            self.notices = [Notice]()
            
            let response = JSON(response_.result.value!)
            
            if response["status"] != "OK" {
                print("error")
                
            } else {
                
                let data = response["data"].arrayValue
                
                self.notices = parseNotices(data: data)
            
                print("Successfully loaded data")
                
            }
            
            self.stopActivityIndicator()
            
            self.refreshControl.endRefreshing()
            self.noticesCollectionView.reloadData()
            
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
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
                
                cell.url = notice.getComponentURL
                cell.titleText = notice.title
                cell.contentText = notice.content
                cell.dateText = notice.date
                
                return cell
                
            } else {
                
                //TODO PDF CELL
                print("PDF CELL FOUND")
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
                
                cell.url = notice.getComponentURL
                cell.titleText = notice.title
                cell.contentText = notice.content
                
                return cell
                
            }
            
        } else {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
            
            cell.titleText = notice.title
            cell.contentText = notice.content
            cell.dateText = notice.date
            
            cell.isUserInteractionEnabled = false
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: NoticeImageCollectionViewCell.width, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0, right: 20.0)
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
    
    @objc func refreshNotices() {
        
        retrieveNotices()
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
