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
    
    let EVENTS_API = "https://api.themitpost.com/events"
    
    var events = [Events]()
    var eventShown = [Bool]()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        eventsCollectionView.addSubview(refreshControl)
        
        retrieveEvents()
        
        refreshControl.addTarget(self, action: #selector(refreshEvents), for: .valueChanged)
        
    }

    // MARK: - Table view data source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventViewCell
        
        cell.event = events[indexPath.row]
        
        return cell
        
    }
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: EventViewCell.cellPadding + 20, left: EventViewCell.cellPadding + 20, bottom: EventViewCell.cellPadding + 20, right: EventViewCell.cellPadding + 20)
    }

    
    //MARK:- RETRIEVE EVENT DATA FROM API
    func retrieveEvents() {
        
        Alamofire.request(EVENTS_API, method: .get).responseJSON {
            response_ in
            
            let response = JSON(response_.result.value!)
            
            if(response["status"].stringValue != "OK") {
                //TODO:- UPDATE BACKGROUND IMAGE TO CONVEY THERE WAS AN ERROR GETTING EVENTS
                print("Cannot get EVENTS")
                
            } else {
                
                let data = response["data"].arrayValue
                
                for event in data {
                    self.events.append(Events(data: event))
                }
            }
            
            self.eventShown = [Bool](repeatElement(false, count: self.events.count + 1))
            
            self.eventsCollectionView.reloadData()
        }
        
    }
    
    @objc func refreshEvents() {
        events = [Events]()
        retrieveEvents()
        print("Finished refreshing..")
    }

}
