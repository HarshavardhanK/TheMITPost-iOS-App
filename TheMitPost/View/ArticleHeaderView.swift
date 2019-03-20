//
//  ArticleHeaderView.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 01/02/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import MaterialComponents

class ArticleHeaderView: UIView {
    
    struct CONSTANTS {
        
        static let statusBarHeight = UIApplication.shared.statusBarFrame.height
        static let minHeight = CGFloat(0.0)
        static let maxHeight = 90 + statusBarHeight
    }
    
    let headerImageView: UIImageView = UIImageView()
    
    init() {
        
        super.init(frame: .zero)
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        clipsToBounds = true
        
        backgroundColor = .white
        
        headerImageView.image = UIImage(named: "thepost-1")
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        
        addSubview(headerImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerImageView.frame = bounds
        
    }
}
