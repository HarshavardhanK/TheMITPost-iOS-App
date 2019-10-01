//
//  EventTableViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 13/07/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import Lottie
import SDWebImage
import MaterialComponents

class EventViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organizerNameLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet var clubLottieView: AnimationView!
    
    var formLink: String?
    
    @IBAction func shareAction(_ sender: Any) {
        print("Share button tapped")
        shareEvent()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        print("button tapped")
        
        if let link_ = formLink {
        
            guard let url = URL(string: link_) else {
                print("No link")
                return
            }
            
            UIApplication.shared.open(url)
            
        }
        
        
    }
    
    static let cellPadding: CGFloat = 12.0
    
    var event: Events! {
        
        didSet {
            
            descriptionLabel.text = event.content
            organizerNameLabel.text = event.organizer
            
            //timeLabel.text = event.date
            titleLabel.text = event.title
            eventImageView.sd_setImage(with: event.imageURL!)
            
            formLink = event.formLink
            
            print("set event cell")
            
            if event.formLink == "NA" {
                
                print("no form link")
                registerButton.isEnabled = false
                registerButton.alpha = 0.85
                
                formLink = ""
            
            } else {
                registerButton.isEnabled = true
                registerButton.alpha = 1.0
            }
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mode()
        clubLottieView.play()
        
        shadowLayer?.elevation = .cardPickedUp
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 8.0
        layer.shadowRadius = 7.5
       
        clipsToBounds = false
        
        eventImageView.layer.masksToBounds = true
        eventImageView.clipsToBounds = true
        
        organizerNameLabel.font = MDCTypography.body1Font()
        organizerNameLabel.alpha = MDCTypography.body1FontOpacity()
        
        titleLabel.font = MDCTypography.titleFont()
        titleLabel.alpha = MDCTypography.titleFontOpacity()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        timeLabel.font = MDCTypography.captionFont()
        timeLabel.alpha = MDCTypography.captionFontOpacity()
        
        descriptionLabel.font = MDCTypography.body1Font()
        descriptionLabel.alpha = MDCTypography.body1FontOpacity()
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        registerButton.layer.cornerRadius = 8
        titleLabel.layer.cornerRadius = 5.0
        titleLabel.layer.shadowRadius = 10.0
        
        eventImageView.isUserInteractionEnabled = true
        
    }
    
    func mode() {
        
        if #available(iOS 13.0, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                backgroundColor = UIColor.foreground
                
                titleLabel.backgroundColor = UIColor.foreground
                timeLabel.backgroundColor = UIColor.foreground
                
                descriptionLabel.backgroundColor = UIColor.foreground
                organizerNameLabel.backgroundColor = UIColor.foreground
                clubLottieView.backgroundColor = .foreground
                titleLabel.textColor = .label
                organizerNameLabel.textColor = .secondaryLabel
                
                
            } else {
                
                backgroundColor = .white
                
                titleLabel.backgroundColor = UIColor.white
                timeLabel.backgroundColor = UIColor.white
                
                descriptionLabel.backgroundColor = UIColor.white
                organizerNameLabel.backgroundColor = UIColor.white
                clubLottieView.backgroundColor = .white
                titleLabel.textColor = .label
                organizerNameLabel.textColor = .secondaryLabel
                
            }
            
            
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        mode()
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
