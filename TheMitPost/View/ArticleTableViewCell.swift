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
    
    var paragraphNumber: Int? {
        
        didSet {
            
            if let p_ = paragraphNumber {
                
                if p_ == 0 {
                    
                    let range = NSRange(location:1,length:1)
                    
                    let attributedString = NSMutableAttributedString(string: "\t")
                    attributedString.append(NSMutableAttributedString(string: (content?.content)!))
                    attributedString.addAttribute(NSMutableAttributedString.Key.font, value: UIFont(name: "Helvetica-Bold", size: 32)! , range: range)
                    
                    paragraph.attributedText = attributedString
//
                    
                }
                
            }
            
        }
        
        
    }
    
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
        
        paragraph.numberOfLines = 0
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.font = UIFont(name: "Avenir-Book", size: 17)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

class ArticleTimeDateViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabelView: UILabel!
    @IBOutlet weak var dateLabelView: UILabel!
    
    var time: String! {
        
        didSet {
            
            timeLabelView.text = time
            
        }
    }
    
    var date: String! {
        
        didSet {
            
            dateLabelView.text = date
        }
    }
    
    let identifier = "timeDateCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timeLabelView.font = UIFont(name: "Avenir-Book", size: 15)
        dateLabelView.font = UIFont(name: "Optima", size: 14)
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
