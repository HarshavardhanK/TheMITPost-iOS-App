//
//  ArticleTableViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 21/03/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var paragraph: UILabel!
    
    var content: Article.Content? {
        didSet {
            
            if let content_ = content {
                paragraph.text = content_.content
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        paragraph.font = UIFont(name: "Avenir-Book", size: 18)
        paragraph.numberOfLines = 0
        paragraph.lineBreakMode = .byWordWrapping
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    

}
