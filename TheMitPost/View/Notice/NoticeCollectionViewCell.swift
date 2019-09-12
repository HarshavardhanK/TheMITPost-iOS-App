//
//  NoticeCollectionViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 11/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

class NoticeTextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var text: String? {
        
        didSet {
            
            if let text_ = text {
                
                textLabel.text = text_
                
                print("Set notice text")
                
            } else {
                print("does not contain text")
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //TODO
        //blah blah
    }
    
    
}

class NoticePDFCollectionViewCell: UICollectionViewCell {
    
    var url: URL? {
        
        //TODO: assign it to an url which will load the pdf in WKWebView
        
        didSet {
            
            if let _ = url {
                print("received url")
            } else {
                print("no url was received")
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //TDODO
    }
    
    
    
}

class NoticeImageCollectionViewCell: UICollectionViewCell {
    
    static var cellHeight: CGFloat = 350.0
    static var cellPadding: CGFloat = 10.0
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var noticeImageView: UIImageView!
    
    var text: String? {
        
        didSet {
            
            if let text_ = text {
                
                textLabel.text = text_
            }
            
        }
    }
    
    var imageURL: URL? {
        
        didSet {
            
            if let url_ = imageURL {
                noticeImageView.sd_setImage(with: url_, completed: nil)
            } else {
                print("Cant set image with url")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
