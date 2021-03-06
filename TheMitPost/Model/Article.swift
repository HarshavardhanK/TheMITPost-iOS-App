//
//  Article.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 15/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import Foundation

class Article {
    
    struct Content {
        
        var content: String
        var isImage: Bool
        var isHyperlink: Bool
        
        init(content: String, isImage: Bool, isHyperlink: Bool) {
            self.content = content
            self.isImage = isImage
            self.isHyperlink = isHyperlink
        }
    }
    
    var articleID: String!
    var title: String?
    var category: String?
    var date: String?
    var featured_media: String?
    var author: String
    var message: String!
    var articleLink: String?
    var content: [Content]?
    
    init(articleID: String, title: String, author: String, date: String, featured_media: String, message_: String?, category_: String?, articleLink: String?, content: [Content]?) {
        
        self.articleID = articleID
        self.title = title
        self.featured_media = featured_media
        self.author = author
        self.date = date
        
        self.articleLink = articleLink
        
        if let mess_ = message_ {
            self.message = mess_
        }
        
        if let cat_ = category_ {
            self.category = cat_
        }
        
        if let content = content {
            self.content = content
            
        }
        
    }
    
    
    
}
