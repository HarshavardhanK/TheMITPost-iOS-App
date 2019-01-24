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

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let cellID: String = "articleCell"
    static let cellHeight: CGFloat = 350.0
    static let cellPadding: CGFloat = 8
    
    var article: Article? {
        
        didSet {
            guard let article = article else {
                return
            }
            
            articleImageView.sd_setImage(with: URL(string:article.imageURLS![0]))
            titleLabel.text = article.title!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = false
        articleImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.sd_cancelCurrentImageLoad()
        titleLabel.text = nil
    }

}
