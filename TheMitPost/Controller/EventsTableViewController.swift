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

class EventsTableViewController: UITableViewController {
    
    let EVENTS_API = "https://api.themitpost.com/events"
    
    var events = [Events]()
    
    //let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 450
        
        self.refreshControl?.addTarget(self, action: #selector(refreshEvents), for: .valueChanged)
        
        
        retrieveEvents()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        cell.event = events[indexPath.row]

        return cell
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
            
            self.tableView.reloadData()
        }
        
    }
    
    @objc func refreshEvents() {
        retrieveEvents()
    }

}
