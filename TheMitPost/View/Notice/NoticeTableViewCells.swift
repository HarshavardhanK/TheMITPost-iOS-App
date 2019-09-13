//
//  NoticeCollectionViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 11/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import MaterialComponents

class NoticeImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noticeImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    var url: URL? {
        
        didSet {
            
            if let url_ = url {
                noticeImageView.sd_setImage(with: url_, completed: nil)
            }
        }
    }
    
    var titleText: String? {
        
        didSet {
            
            if let title_ = titleText {
                title.text = title_
            }
        }
    }
    
    var contentText: String? {
        
        didSet {
            
            if let content_ = contentText {
                content.text = content_
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowLayer?.elevation = .cardResting
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 5.0
        layer.shadowRadius = 10.0
        
        clipsToBounds = false
        
        noticeImageView.clipsToBounds = true
        noticeImageView.layer.masksToBounds = true
        noticeImageView.clipsToBounds = true
        
        title.font = MDCTypography.titleFont()
        title.alpha = MDCTypography.titleFontOpacity()
        
        content.font = MDCTypography.body1Font()
        content.alpha = MDCTypography.body1FontOpacity()
    }
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }
    
}

class NoticePDFTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         shadowLayer?.elevation = .cardResting
    }
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }
    
}

class NoticeTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    
    var titleText: String? {
        
        didSet {
            
            if let title_ = titleText {
                title.text = title_
            }
        }
    }
    
    var contentText: String? {
        
        didSet {
            
            if let content_ = contentText {
                content.text = content_
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        shadowLayer?.elevation = .cardResting
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 5.0
        layer.shadowRadius = 10.0
        
        clipsToBounds = false
        
        title.font = MDCTypography.titleFont()
        title.alpha = MDCTypography.titleFontOpacity()
        
        content.font = MDCTypography.body1Font()
        content.alpha = MDCTypography.body1FontOpacity()
        
    }
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }
    
}
