//
//  Article.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 15/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import Foundation

class Article {
    
    var articleID: Int!
    var title: String?
    var date: String?
    var content: Array<String>?
    var imageURLS: Array<String>?
    var articleLength: Int!
    
    init(articleID: Int, title: String, date: String, content: Array<String>, imageURLS: Array<String>?) {
        
        self.articleID = articleID
        self.title = title
        self.date = date
        self.content = content
        
        if let images = imageURLS {
            self.imageURLS = images
        }
        
        articleLength = content.count
        
    }
    
    
}
