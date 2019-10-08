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
    var url: String?
    var date: String?
    
    
    init(data: JSON) {
        
        title = data["title"].stringValue
        content = data["content"].stringValue
        date = Date.dateString(strDate: data["date"].stringValue)
        
        if data["imageLink"].stringValue != "" {
            url = data["imageLink"].stringValue
            
        } else if data["pdfLink"].stringValue != "" {
            url = data["pdfLink"].stringValue
        }
        
    }
    
    var getComponentURL: URL? {
        
        guard let url_ = url else {
            return nil
        }
        
        return URL(string: url_)
    }
    
    var isImage: Bool {
        
        guard let url_ = url else {
            return false
        }
        
        print(url_)
        
        if url_.contains("jpeg") || url_.contains("jpg") || url_.contains("png") {
            return true
            
        }
        
        return false
    }
    
    var isPDF: Bool {
        
        guard let url_ = url else {
            return false
        }
        
        if url_.contains("pdf") {
            return true
        }
        
        return false
        
    }
    
    var hasURL: Bool {
        
        guard let url_ = url else {
            return false
        }
        
        if url_ == "" {
            return false
        }
        
        return true
    }
    
}

func parseNotices(data: [JSON]) -> [Notice] {
    
    var _notices = [Notice]()
    
    for notices in data {
        
        print(notices["title"])
        
        let notice = Notice(data: notices)
        _notices.append(notice)
    }
    
    return _notices
}
