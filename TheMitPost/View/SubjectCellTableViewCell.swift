//
//  SubjectCellTableViewCell.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 25/05/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import FoldingCell

// The summary view of the SLCM subject will be displayed in the FoldingCell property foregroundView
// The detail view of the SLCm subject will be displayed in the FoldingCell property containerView

class SubjectCellTableViewCell: FoldingCell {
    
    // Use property getters and setters to
    
//    var subject: Subject {
//        
//        didSet {
//            
//        }
//    }
    
//    @IBOutlet var closeNumberLabel: UILabel!
//    @IBOutlet var openNumberLabel: UILabel!

    override func awakeFromNib() {
        // Initialization code
        
        foregroundView.layer.cornerRadius = 15
        foregroundView.layer.masksToBounds = true
        
        print("Awoke from nib..")
        super.awakeFromNib()
        //
    }
    
//    func getRandomColor() -> UIColor {
//        //let colors : [UIColor]()
//        //TODO: Have an array of hex light colors, and matching expanded view color. Create pairs //CREATE CLASS
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.25, 0.35]
        return durations[itemIndex]
    }
    
}


