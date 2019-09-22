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
        shareEvent()
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
            
            layer.shadowColor = UIColor.lightGray.cgColor
            titleLabel.backgroundColor = .systemBackground
            timeLabel.backgroundColor = .systemBackground
            descriptionLabel.backgroundColor = .systemBackground
            organizerNameLabel.backgroundColor = .systemBackground
            
            titleLabel.textColor = .label
            organizerNameLabel.textColor = .secondaryLabel
            
        }
        
    }
    
    func shareEvent() {
        
        let items = [titleLabel.text, descriptionLabel.text, event.formLink]
        
        let shareActivityController = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
           //present(shareActivityController, animated: true)
        self.window?.rootViewController?.present(shareActivityController, animated: true)
        
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
