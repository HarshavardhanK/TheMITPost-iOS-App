//
//  EventTableViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 13/07/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import SDWebImage
import MaterialComponents

class EventViewCell: UICollectionViewCell {

    @IBOutlet weak var organizerNameLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let cellPadding: CGFloat = 22.0
    
    var event: Events! {
        
        didSet {
            
            descriptionLabel.text = event.content
            organizerNameLabel.text = event.organizer
            timeLabel.text = event.date
            eventImageView.sd_setImage(with: event.imageURL!)
            
            print("set event cell")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowLayer?.elevation = .cardPickedUp
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 12.0
        layer.shadowRadius = 15.0
        
        clipsToBounds = false
        eventImageView.clipsToBounds = true
        
        organizerNameLabel.font = MDCTypography.headlineFont()
        organizerNameLabel.alpha = MDCTypography.headlineFontOpacity()
        
        timeLabel.font = MDCTypography.captionFont()
        timeLabel.alpha = MDCTypography.captionFontOpacity()
        
        descriptionLabel.font = MDCTypography.body1Font()
        descriptionLabel.alpha = MDCTypography.body1FontOpacity()
        
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        organizerNameLabel.text = nil
        descriptionLabel.text = nil
        timeLabel.text = nil
    }
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }

}
