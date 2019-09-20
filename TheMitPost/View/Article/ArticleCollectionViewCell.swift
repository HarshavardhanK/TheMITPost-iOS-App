//
//  ArticleCollectionViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 15/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import SDWebImage
import MaterialComponents

class ArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabelView: UILabel!
   // @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var messageLabelView: UILabel!
    
    static let cellID: String = "articleCell"
    static let cellHeight: CGFloat = 400.0
    static let cellPadding: CGFloat = 5 // DO NOT CHANGE THIS VALUE. WORKS PERFECTLY
    
    var article: Article? {
        
        didSet {
            
            guard let article = article else {
                return
            }
            
            articleImageView.sd_setImage(with: URL(string: article.featured_media!))
            titleLabelView.text = article.title
           // authorLabel.text = article.author
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
        
        shadowLayer?.elevation = .cardPickedUp
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 5.0
        layer.shadowRadius = 10.0
        //layer.backgroundColor = UIColor(patternImage: UIImage(imageLiteralResourceName: "event_bg3")).cgColor
        
        clipsToBounds = false
        
        articleImageView.clipsToBounds = true
        
        self.contentView.layer.cornerRadius = 10.0

        print("Awake from nib")
        //clipsToBounds = false
        //articleImageView.clipsToBounds = true
        
        titleLabelView.lineBreakMode = .byWordWrapping
        titleLabelView.numberOfLines = 3
        titleLabelView.font = UIFont(name: "Optima-Bold", size: 21)
        
        messageLabelView.lineBreakMode = .byWordWrapping
        messageLabelView.numberOfLines = 0
        
        messageLabelView.lineBreakMode = .byWordWrapping
        messageLabelView.numberOfLines = 0
        messageLabelView.font = UIFont(name: "Optima", size: 15)
        
       // authorLabel.font = UIFont(name: "Optima", size: 16)
        dateLabelView.font = UIFont(name: "Helvetica", size: 14)
        
        darkMode()
        
    }
    
    func darkMode() {
        
        if #available(iOS 13.0, *) {
            
            backgroundColor = .systemBackground
            
            dateLabelView.backgroundColor = .systemBackground
            titleLabelView.backgroundColor = .systemBackground
            titleLabelView.backgroundColor = .systemBackground
            
        } else {
            // Fallback on earlier versions
        }
        
    }

    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.sd_cancelCurrentImageLoad()
        titleLabelView.text = nil
    }

}
