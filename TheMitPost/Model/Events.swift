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
    
    var title: String?
    var content: String?
    var imageURL: URL?
    var date: Date?
    
    
    init(data: JSON) {
        title = data["title"].stringValue
        content = data["content"].stringValue
        imageURL = URL(string: data["imageURL"].stringValue)
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