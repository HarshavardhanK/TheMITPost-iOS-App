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
        
        mode()
        
        shadowLayer?.elevation = .cardPickedUp
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 5.0
        layer.shadowRadius = 10.0
        
        clipsToBounds = false
        
        articleImageView.clipsToBounds = true
        
        self.contentView.layer.cornerRadius = 10.0

        titleLabelView.lineBreakMode = .byWordWrapping
        titleLabelView.numberOfLines = 3
        titleLabelView.font = UIFont(name: "Optima-Bold", size: 21)
        
        messageLabelView.lineBreakMode = .byWordWrapping
        messageLabelView.numberOfLines = 0
        
        messageLabelView.lineBreakMode = .byWordWrapping
        messageLabelView.numberOfLines = 0
        messageLabelView.font = UIFont(name: "Optima", size: 15)
    
        dateLabelView.font = UIFont(name: "Helvetica", size: 14)
        
    }
    
    func mode() {
        
        if #available(iOS 13.0, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                backgroundColor = UIColor.foreground
                
                dateLabelView.backgroundColor = UIColor.foreground
                titleLabelView.backgroundColor = UIColor.foreground
                
                messageLabelView.textColor = .secondaryLabel
                dateLabelView.textColor = .tertiaryLabel
                titleLabelView.textColor = .label
                
            } else {
                
                backgroundColor = UIColor.white
                
                dateLabelView.backgroundColor = UIColor.white
                titleLabelView.backgroundColor = UIColor.white
                
                messageLabelView.textColor = .secondaryLabel
                dateLabelView.textColor = .tertiaryLabel
                titleLabelView.textColor = .label
                
            }
        
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
