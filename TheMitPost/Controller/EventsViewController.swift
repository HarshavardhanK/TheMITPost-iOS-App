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
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        
        retrieveEvents()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventViewCell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(35)
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
            
            self.eventsCollectionView.reloadData()
        }
        
    }
    
    @objc func refreshEvents() {
        retrieveEvents()
    }

}
