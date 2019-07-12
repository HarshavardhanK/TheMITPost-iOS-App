//
//  ArticleImageTableViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 21/03/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

class ArticleImageTableViewCell: UITableViewCell {

    @IBOutlet weak var paragraphImageView: UIImageView!
    
    var content: Article.Content? {
        
        didSet {
            
            if let content_ = content {
                paragraphImageView.sd_setImage(with: URL(string: content_.content), completed: nil)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("Paragraph image cell loaded..")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        paragraphImageView.sd_cancelCurrentImageLoad()
        
    }

}
