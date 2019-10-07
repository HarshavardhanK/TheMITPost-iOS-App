//
//  NoticeCollectionViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 18/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

import Lottie
import MaterialComponents

class NoticeImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noticeImageView: UIImageView!
    
    static let height: CGFloat = 365.0
    static let width: CGFloat = 350.0
    
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
                titleLabel.text = title_
            }
        }
    }
    
    var contentText: String? {
        
        didSet {
            
            if let content_ = contentText {
                contentLabel.text = content_
            }
        }
    }
    
    var dateText: String? {
        
        didSet {
            
            if let date_ = dateText {
                dateLabel.text = date_
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowLayer?.elevation = .cardResting
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 5.0
        //layer.shadowRadius = 5.0
        
        clipsToBounds = false
        
        noticeImageView.clipsToBounds = true
        noticeImageView.layer.masksToBounds = true
        noticeImageView.clipsToBounds = true
        
        titleLabel.font = MDCTypography.titleFont()
        titleLabel.alpha = MDCTypography.titleFontOpacity()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        contentLabel.font = MDCTypography.body1Font()
        contentLabel.alpha = MDCTypography.body1FontOpacity()
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
    }
    
    func mode() {
        
        if #available(iOS 13, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                backgroundColor = .foreground
                contentLabel.backgroundColor = .foreground
                dateLabel.backgroundColor = .foreground
                titleLabel.backgroundColor = .foreground
                
                contentLabel.textColor = .secondaryLabel
                titleLabel.textColor = .label
                dateLabel.textColor = .tertiaryLabel
                
            } else {
                
                backgroundColor = .white
                contentLabel.backgroundColor = .white
                dateLabel.backgroundColor = .white
                titleLabel.backgroundColor = .white
                               
                contentLabel.textColor = .secondaryLabel
                titleLabel.textColor = .label
                dateLabel.textColor = .tertiaryLabel
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        mode()
    }
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }
}

class NoticeTextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var arrowLottieView: AnimationView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let height: CGFloat = 120.0
    static let width: CGFloat = 350.0
    
    var isPDF: Bool = false
    
    var titleText: String? {
        
        didSet {
            
            if let title_ = titleText {
                titleLabel.text = title_
            }
        }
    }
    
    var contentText: String? {
        
        didSet {
            
            if let content_ = contentText {
                contentLabel.text = content_
            }
        }
    }
    
    var url: URL? {
        
        didSet {
            
            if let _ = url {
                isPDF = true
                
            } else {
                arrowImageView.alpha = 0
            }
            
        }
        
    }
    
    var dateText: String? {
        
        didSet {
            
            if let date_ = dateText {
                dateLabel.text = date_
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mode()
        
        shadowLayer?.elevation = .cardResting
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 7.5
        //layer.shadowRadius = 4.0
        
        clipsToBounds = false
        
        titleLabel.font = MDCTypography.titleFont()
        titleLabel.alpha = MDCTypography.titleFontOpacity()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        contentLabel.font = MDCTypography.body1Font()
        contentLabel.alpha = MDCTypography.body1FontOpacity()
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        
    }
    
    func mode() {
        
        if #available(iOS 13, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                backgroundColor = .foreground
                contentLabel.backgroundColor = .foreground
                dateLabel.backgroundColor = .foreground
                titleLabel.backgroundColor = .foreground
                
                contentLabel.textColor = .secondaryLabel
                titleLabel.textColor = .label
                dateLabel.textColor = .tertiaryLabel
                
                let animation = Animation.named("right-dark", subdirectory: "Lottie-Files")
                arrowLottieView.animation = animation
                arrowLottieView.backgroundColor = .foreground
                arrowLottieView.loopMode = .loop
                arrowLottieView.play()
                
            } else {
                
                backgroundColor = .white
                contentLabel.backgroundColor = .white
                dateLabel.backgroundColor = .white
                titleLabel.backgroundColor = .white
                               
                contentLabel.textColor = .secondaryLabel
                titleLabel.textColor = .label
                dateLabel.textColor = .tertiaryLabel
                
                let animation = Animation.named("right-light", subdirectory: "Lottie-Files")
                arrowLottieView.animation = animation
                arrowLottieView.backgroundColor = .white
                arrowLottieView.loopMode = .loop
                arrowLottieView.play()
            }
            
        } else {
            
            let animation = Animation.named("right-light", subdirectory: "Lottie-Files")
            arrowLottieView.animation = animation
            arrowLottieView.backgroundColor = .white
            arrowLottieView.loopMode = .loop
            arrowLottieView.play()
            
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        mode()
    }
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }
    
}

