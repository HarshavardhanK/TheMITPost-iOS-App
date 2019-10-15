//
//  NoticesCollectionViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 18/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import NotificationCenter

import NotificationBannerSwift
import Lottie
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

class NoticesCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let API = "https://app.themitpost.com/notices"
    var isNotification: Bool?
    
    @IBOutlet weak var noticesCollectionView: UICollectionView!
    
    var notices = [Notice]()
    var noticesShown = [Bool]()
    
    let refreshControl = UIRefreshControl()
    
    var notificationCenter = NotificationCenter.default
    
    //MARK: VIEW WILL DID APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("View will appear")
        
        mode()
    }
    
    func setupNotificationCenter() {
        notificationCenter.addObserver(self, selector: #selector(refresh), name: Notification.Name("notice"), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mode()
        startActivityIndicator()
        
        retrieveNotices() { (result) in
            
            if !result {
                self.emptyView(action: "make")
            }
            
        }
        
        setupNotificationCenter()
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: NoticeImageCollectionViewCell.width, height: 120.0)
        
       // noticesCollectionView.collectionViewLayout = layout
        noticesCollectionView.delegate = self
        noticesCollectionView.dataSource = self
        
        noticesCollectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
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
    
    //MARK: CREATE EMPTY VIEW
    let emptyImageView = AnimationView()
    
    var emptyLabel = UILabel()
    var refreshButton = UIButton()
    
    func emptyView(action: String) {
        
        if action == "make" {
            let animation = Animation.named("empty-box")
            emptyImageView.animation = animation
            emptyImageView.loopMode = .loop
            
            emptyLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 120, width: 200, height: 30))
            emptyLabel.center.x = self.view.center.x
            emptyLabel.text = "Could not fetch notices.."
            self.view.addSubview(emptyLabel)
            
            emptyImageView.frame = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 100, width: 250, height: 250.0)
            emptyImageView.center.x = self.view.center.x
            
            self.view.addSubview(emptyImageView)
            emptyImageView.play()
            
            refreshButton = UIButton(frame: CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 + 150, width: 150, height: 30))
            refreshButton.center.x = self.view.center.x
            refreshButton.layer.cornerRadius = 8
            refreshButton.backgroundColor = .systemGray
            refreshButton.backgroundColor = .clear
            refreshButton.setTitle("Tap to refresh", for: .normal)
            refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
            
            self.view.addSubview(refreshButton)
            
        }
        
        
        else if action == "remove" {
            
            print("removing empty views")
            emptyImageView.removeFromSuperview()
            refreshButton.removeFromSuperview()
            emptyLabel.removeFromSuperview()
            
        }
        
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
            
            self.navigationController?.navigationBar.backgroundColor = .systemOrange
            self.tabBarController?.tabBar.barTintColor = .white
            
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
       mode()
    }

    //MARK: API CALL
    
    func retrieveNotices(completion: @escaping (Bool) -> ()) {
        
        Alamofire.request(API, method: .get).responseJSON {
            response_ in
            
            self.notices = [Notice]()
            
            guard let resultValue = response_.result.value else {
                //MARK: Data connection banner
                
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
                
                let banner = StatusBarNotificationBanner(title: "Oops! Check your internet connection", style: .danger)
                banner.haptic = .heavy
                banner.show()
                
                completion(false)
                return
            }
            
            let value = JSON(resultValue)
            
            if value["status"] != "OK" {
                completion(false)
                self.stopActivityIndicator()
                return
                
            } else {
                
                let data = value["data"].arrayValue
                
                self.notices = parseNotices(data: data)
            
                print("Successfully loaded data")
                
                if self.notices.count == 0 {
                    completion(false)
                    
                } else {
                    
                    self.noticesShown = [Bool](repeating: false, count: self.notices.count)
                    
                    completion(true)
                    
                    self.notices.reverse()
                    
                }
                
            }
            
            self.stopActivityIndicator()
            
            self.refreshControl.endRefreshing()
            self.noticesCollectionView.reloadData()
            
            print("\(self.notices.count) notices retrieved")
        }
        
    }
    
    @objc func refresh() {
        
        retrieveNotices() { (result) in
            
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
                
                cell.isUserInteractionEnabled = true
                cell.arrowLottieView.alpha = 1
                
                return cell
                
            } else {
                
                //TODO PDF CELL
                print("PDF CELL FOUND")
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
                
                cell.url = notice.getComponentURL
                cell.titleText = notice.title
                cell.contentText = notice.content
                cell.isUserInteractionEnabled = true
                cell.arrowLottieView.alpha = 1
                
                return cell
                
            }
            
        } else {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoticeTextCollectionViewCell
            
            cell.titleText = notice.title
            cell.contentText = notice.content
            cell.dateText = notice.date
            cell.arrowLottieView.alpha = 0
            cell.isUserInteractionEnabled = false
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if noticesShown[indexPath.row] == false {
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 80, 10)
            cell.layer.transform = transform
            cell.alpha = 0.4
            
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
                
            }) { (true) in
                print("Animation complete")
                
            }
            
            noticesShown[indexPath.row] = true
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.width - (EventViewCell.cellPadding), height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: EventViewCell.cellPadding + 20, left: EventViewCell.cellPadding + 20, bottom: EventViewCell.cellPadding + 20, right: EventViewCell.cellPadding + 20)
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

}
