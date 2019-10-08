//
//  EventsTableViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 10/07/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

import NotificationCenter
import NotificationBannerSwift
import Lottie
import NVActivityIndicatorView
import SwiftyJSON
import Alamofire

class EventsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var notificationCenter = NotificationCenter.default
    
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    let EVENTS_API = "https://app.themitpost.com/events"
    
    var events = [Events]()
    var eventShown = [Bool]()
    
    let refreshControl = UIRefreshControl()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: VIEW WILL DID LOAD
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mode()
    }
    
    func setupNotificationCenter() {
        notificationCenter.addObserver(self, selector: #selector(refresh), name: Notification.Name("event"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationCenter()
        
        mode()
        
        startActivityIndicator()

        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        eventsCollectionView.addSubview(refreshControl)
        
        retrieveEvents { (success) in
            
            if !success {
                
                self.emptyView(action: "make")
            }
            
        }
        
        refreshControl.addTarget(self, action: #selector(refreshEvents), for: .valueChanged)
        
    }
    
    //MARK: ACTIVITY INDICATOR
    var activityIndicator: NVActivityIndicatorView!
    func startActivityIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 45, height: 45), type: .cubeTransition, color: .lightGray, padding: 0)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    //MARK: EMPTY LOTTIE VIEW
    
    //MARK: CREATE EMPTY VIEW
    let emptyImageView = AnimationView(name: "empty-box")
    var emptyLabel = UILabel()
    var refreshButton = UIButton()
    
    func emptyView(action: String) {
        
        if action == "make" {
            
            emptyLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 90, width: 200, height: 30))
            emptyLabel.center.x = self.view.center.x
            emptyLabel.text = "Could not fetch events.."
            self.view.addSubview(emptyLabel)
            
            emptyImageView.frame = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 100, width: 250, height: 250)
            emptyImageView.center.x = self.view.center.x
            
            self.view.addSubview(emptyImageView)
            emptyImageView.play()
            
            refreshButton = UIButton(frame: CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 + 150, width: 150, height: 30))
            refreshButton.center.x = self.view.center.x
            refreshButton.layer.cornerRadius = 8
            refreshButton.backgroundColor = .systemGray
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
    
    @objc func refresh() {
        
        emptyView(action: "remove")
        startActivityIndicator()
        
        retrieveEvents { (success) in
            
            if success {
                
                let banner = StatusBarNotificationBanner(title: "Great! Internet connection is back", style: .success)
                banner.show()
                banner.haptic = .light
                
                self.emptyView(action: "remove")
                
            } else {
                self.emptyView(action: "make")
                self.stopActivityIndicator()
            }
        }
        
    }
    
    //MARK:- DARK MODE CHECK
    
    func mode() {
        
        if #available(iOS 13.0, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                print("dark mode detected")
                self.navigationController?.navigationBar.barTintColor = .background
                self.tabBarController?.tabBar.barTintColor = .background

                self.view.backgroundColor = UIColor.background
                eventsCollectionView.backgroundColor = UIColor.background
                
            } else {
                
                print("light mode detected")
                self.navigationController?.navigationBar.barTintColor = .white
                self.tabBarController?.tabBar.barTintColor = .white
                
                self.view.backgroundColor = .white
                eventsCollectionView.backgroundColor = .white
                
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
    

    // MARK: - TABLE VIEW COUNT

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    //MARK: TABLE VIEW RETURN CELL
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventViewCell
        
        cell.event = events[indexPath.row]
        
        return cell
        
    }

    
    //MARK: TABLE VIEW ANIMATION
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if eventShown[indexPath.row] == false {
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, -5, 80, 0)
            cell.layer.transform = transform
            cell.alpha = 0.4
            
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
                
            }) { (true) in
                print("Animation complete")
                
            }
            
            eventShown[indexPath.row] = true
            
        }
    }
    
    //MARK: TABLE VIEW CELL RESIZES / PADDING / ETC
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.width - (EventViewCell.cellPadding), height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: EventViewCell.cellPadding + 20, left: EventViewCell.cellPadding + 20, bottom: EventViewCell.cellPadding + 20, right: EventViewCell.cellPadding + 20)
    }

    
    //MARK:- API CALL
    func retrieveEvents(completion: @escaping (Bool) -> ()) {
        
        Alamofire.request(EVENTS_API, method: .get).responseJSON {
            response_ in
            
            self.events = [Events]()
            
            guard let resultValue = response_.result.value else {
                
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
                
                let banner = NotificationBanner(title: "Oops! Check your internet connection", style: .danger)
                banner.haptic = .heavy
                banner.show()
                
                completion(false)
                return
            }
            
            let response = JSON(resultValue)
            
            if(response["status"].stringValue != "OK") {
                //TODO:- UPDATE BACKGROUND IMAGE TO CONVEY THERE WAS AN ERROR GETTING EVENTS
                print("Cannot get EVENTS")
                self.refreshControl.endRefreshing()
                completion(false)
                
            } else {
                
                let data = response["data"].arrayValue
                
                for event in data {
                    self.events.append(Events(data: event))
                }
            }
            
            completion(true)
            
            self.eventShown = [Bool](repeatElement(false, count: self.events.count + 1))
            
            self.refreshControl.endRefreshing()
            
            self.stopActivityIndicator()
            
            self.eventsCollectionView.reloadData()
        }
        
    }
    
    //MARK: REFRESH
    
    @objc func refreshEvents() {
        
        retrieveEvents { (success) in
            
            if !success {
                
            }
            
        }
        
        print("Finished refreshing..")
    }
    
    //MARK: DETAIL IMAGE SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailEvent" {
            
            if let destinationViewController = segue.destination as? ImagePresentViewController {
                
                let path = self.eventsCollectionView.indexPath(for: sender as! EventViewCell)
                
                destinationViewController.image_url = events[(path?.row)!].imageURL
            }
        }
    }

}
