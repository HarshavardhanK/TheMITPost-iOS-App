//
//  EventsTableViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 10/07/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire

class EventsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()

        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        eventsCollectionView.addSubview(refreshControl)
        
        retrieveEvents { (success) in
            
            if !success {
                
                let emptyImageView = UIImageView(image: UIImage(named: "post-empty"))
                emptyImageView.frame = CGRect(origin: self.view.bounds.origin, size: CGSize(width: 300, height: 237))
                
                self.view.addSubview(emptyImageView)
            }
            
        }
        
        refreshControl.addTarget(self, action: #selector(refreshEvents), for: .valueChanged)
        
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
            cell.alpha = 0.5
            
            
            UIView.animate(withDuration: 0.8, delay: 0.1, options: [.curveEaseOut, .allowUserInteraction], animations: {
                
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: EventViewCell.cellPadding + 20, left: EventViewCell.cellPadding + 20, bottom: EventViewCell.cellPadding + 20, right: EventViewCell.cellPadding + 20)
    }

    
    //MARK:- API CALL
    func retrieveEvents(completion: @escaping (Bool) -> ()) {
        
        Alamofire.request(EVENTS_API, method: .get).responseJSON {
            response_ in
            
            guard let resultValue = response_.result.value else {
                completion(false)
                return
            }
            
            let response = JSON(resultValue)
            
            if(response["status"].stringValue != "OK") {
                //TODO:- UPDATE BACKGROUND IMAGE TO CONVEY THERE WAS AN ERROR GETTING EVENTS
                print("Cannot get EVENTS")
                
            } else {
                
                let data = response["data"].arrayValue
                
                for event in data {
                    self.events.append(Events(data: event))
                }
            }
            
            completion(true)
            
            self.eventShown = [Bool](repeatElement(false, count: self.events.count + 1))
            
            self.eventsCollectionView.reloadData()
        }
        
    }
    
    //MARK: REFRESH
    
    @objc func refreshEvents() {
        
        events = [Events]()
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
                
                let path = self.eventsCollectionView.indexPath(for: (sender as? EventViewCell)!)
                
                destinationViewController.image_url = events[(path?.row)!].imageURL
            }
        }
    }

}
