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
    
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var credits: UILabel!
    
    @IBOutlet weak var assignment1: UILabel!
    @IBOutlet weak var assignment3: UILabel!
    @IBOutlet weak var assignment2: UILabel!
    @IBOutlet weak var assignment4: UILabel!
    
    
    @IBOutlet weak var sessional1: UILabel!
    @IBOutlet weak var sessional2: UILabel!
    
  
    @IBOutlet weak var bunks: UILabel!
    @IBOutlet weak var attendancePercentage: UILabel!
    @IBOutlet weak var attendancePercentage2: UILabel!
    
    var subject: Subject? {
        
        didSet {
            
            if let _subject = subject {
                
                assignment1.text = "\(_subject.marks?.assignmentMarks[0] ?? -1.0)"
                assignment2.text = "\(_subject.marks?.assignmentMarks[1] ?? -1.0)"
                assignment3.text = "\(_subject.marks?.assignmentMarks[2] ?? -1.0)"
                assignment4.text = "\(_subject.marks?.assignmentMarks[3] ?? -1.0)"
                
                sessional1.text = "11.5"
                sessional2.text = "12.5"
                
                
            }
            
            
        }
    }
    
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


