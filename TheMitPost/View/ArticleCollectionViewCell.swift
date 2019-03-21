//
//  ArticleCollectionViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 15/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabelView: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var messageLabelView: UILabel!
    
    static let cellID: String = "articleCell"
    static let cellHeight: CGFloat = 430.0
    static let cellPadding: CGFloat = 2
    
    var article: Article? {
        
        didSet {
            
            guard let article = article else {
                return
            }
            
            articleImageView.sd_setImage(with: URL(string: article.featured_media!))
            titleLabelView.text = article.title
            authorLabel.text = article.author
            dateLabelView.text = article.date
            
            if let message = article.message {
                messageLabelView.text = message
            } else {
                print("Article has no message")
            }
            
        }
        
    }
    
    @IBOutlet weak var imageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHorizontalConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.cornerRadius = 10.0

        print("Awake from nib")
        //clipsToBounds = false
        //articleImageView.clipsToBounds = true
        
        titleLabelView.lineBreakMode = .byWordWrapping
        titleLabelView.numberOfLines = 0
        titleLabelView.font = UIFont(name: "Optima-Bold", size: 21)
        
        messageLabelView.lineBreakMode = .byWordWrapping
        messageLabelView.numberOfLines = 0
        
        messageLabelView.lineBreakMode = .byWordWrapping
        messageLabelView.numberOfLines = 0
        messageLabelView.font = UIFont(name: "Optima", size: 15)
        
        authorLabel.font = UIFont(name: "Optima", size: 16)
        dateLabelView.font = UIFont(name: "Helvetica", size: 12)
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.sd_cancelCurrentImageLoad()
        titleLabelView.text = nil
    }

}
