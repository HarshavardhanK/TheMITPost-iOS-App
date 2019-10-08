//
//  Events.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 10/07/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import Foundation
import SwiftyJSON

class Events {
    
    var organizer: String
    var title: String?
    var content: String?
    var imageURL: URL?
    var date: String?
    var location: String?
    var formLink: String? = nil
    
    
    init(data: JSON) {
        
        organizer = data["clubName"].stringValue
        title = data["title"].stringValue
        content = data["content"].stringValue
        imageURL = URL(string: data["imageURL"].stringValue)
        date = Date.dateString(strDate: data["date"].stringValue)
        location = data["location"].stringValue
        formLink = data["formLink"].stringValue
        
    }
    
    static func parseNotices(data: [JSON]) -> [Events] {
        
        var _events = [Events]()
        
        for events in data {
            
            let event = Events(data: events)
            _events.append(event)
        }
        
        return _events
    }
    
}
