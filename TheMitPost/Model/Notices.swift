//
//  Notices.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 12/06/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import Foundation
import SwiftyJSON

class Notice {
    
    var title: String?
    var content: String?
    var imageURL: URL?
    var date: Date?
    
    
    init(data: JSON) {
        title = data["title"].stringValue
        content = data["content"].stringValue
        imageURL = URL(string: data["imageURL"].stringValue)
    }
    
    static func parseNotices(data: [JSON]) -> [Notice] {
        
        var _notices = [Notice]()
        
        for notices in data {
            
            let notice = Notice(data: notices)
            _notices.append(notice)
        }
        
        return _notices
    }
    
}
