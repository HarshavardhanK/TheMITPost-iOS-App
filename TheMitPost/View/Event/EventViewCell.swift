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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organizerNameLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func shareAction(_ sender: Any) {
        print("Share button tapped")
    }
    
    @IBAction func registerAction(_ sender: Any) {
        print("button tapped")
    }
    
    static let cellPadding: CGFloat = 15.0
    
    var event: Events! {
        
        didSet {
            
            descriptionLabel.text = event.content
            organizerNameLabel.text = event.organizer
            
            //timeLabel.text = event.date
            titleLabel.text = event.title
            eventImageView.sd_setImage(with: event.imageURL!)
            
            print("set event cell")
            
           // registerButton.backgroundColor = UIColor.init(red: 100.0, green: 70.0, blue: 28.0, alpha: 1.0)   //UIColor(patternImage: UIImage(imageLiteralResourceName: "event_bg2"))
            
            
            if event.formLink == nil {
                print("no form link")
                registerButton.backgroundColor = .white
            
            }
            
        }
    }
    
    
    
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
        
        eventImageView.layer.masksToBounds = true
        eventImageView.clipsToBounds = true
        
        organizerNameLabel.font = MDCTypography.body1Font()
        organizerNameLabel.alpha = MDCTypography.body1FontOpacity()
        
        titleLabel.font = MDCTypography.titleFont()
        titleLabel.alpha = MDCTypography.titleFontOpacity()
        
        timeLabel.font = MDCTypography.captionFont()
        timeLabel.alpha = MDCTypography.captionFontOpacity()
        
        descriptionLabel.font = MDCTypography.body1Font()
        descriptionLabel.alpha = MDCTypography.body1FontOpacity()
        
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        registerButton.layer.cornerRadius = 5
        titleLabel.layer.cornerRadius = 5.0
        titleLabel.layer.shadowRadius = 10.0
        
        darkMode()
        
    }
    
    func darkMode() {
        
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
            titleLabel.backgroundColor = .systemBackground
            timeLabel.backgroundColor = .systemBackground
            descriptionLabel.backgroundColor = .systemBackground
            organizerNameLabel.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        
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
