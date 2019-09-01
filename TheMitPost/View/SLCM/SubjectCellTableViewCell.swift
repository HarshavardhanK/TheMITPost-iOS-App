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
    
    @IBOutlet weak var absent: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var present: UILabel!
    
    @IBOutlet weak var assignment1: UILabel!
    @IBOutlet weak var assignment3: UILabel!
    @IBOutlet weak var assignment2: UILabel!
    @IBOutlet weak var assignment4: UILabel!
    
    @IBOutlet weak var sessional1: UILabel!
    @IBOutlet weak var sessional2: UILabel!
    
    @IBOutlet weak var totalClasses: UILabel!
    @IBOutlet weak var bunks: UILabel!
    @IBOutlet weak var attendancePercentage: UILabel!
    @IBOutlet weak var attendancePercentage2: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var updateView: UIView!
    
    var subject: Subject? {
        
        didSet {
            
            if let _subject = subject {
                
                subjectName.text = _subject.subjectName
                
                if let a1 = _subject._marks?.assignmentMarks?[0] {
                    assignment1.text = a1
                } else {
                    assignment1.text = ERROR_CODES.NOT_AVAILABLE
                }
                
                if let a2 = _subject._marks?.assignmentMarks?[1] {
                    assignment2.text = a2
                } else {
                    assignment2.text = ERROR_CODES.NOT_AVAILABLE
                }
                
                if let a3 = _subject._marks?.assignmentMarks?[2] {
                    assignment3.text = a3
                } else {
                    assignment3.text = ERROR_CODES.NOT_AVAILABLE
                }
                
                if let a4 = _subject._marks?.assignmentMarks?[3] {
                    assignment4.text = a4
                } else {
                    assignment4.text = ERROR_CODES.NOT_AVAILABLE
                }
                
                if let s1 = _subject._marks?.sessionalMarks?[0] {
                    sessional1.text = s1
                } else {
                    sessional1.text = ERROR_CODES.NOT_AVAILABLE
                }
                
                if let s2 = _subject._marks?.sessionalMarks?[0] {
                    sessional2.text = s2
                } else {
                    sessional2.text = ERROR_CODES.NOT_AVAILABLE
                }
                
                
                guard let attendance = _subject._attendance else {
                    return
                }
                
                bunks.text = attendance.classesAbsent
                absent.text = attendance.classesAbsent
                
                present.text = attendance.classesPresent
                totalClasses.text = attendance.totalClasses
                
                attendancePercentage.text = attendance.attendancePercentString
                attendancePercentage2.text = attendance.attendancePercentString
                
                detailLabel.backgroundColor = attendance.colorCode
                updateView.backgroundColor = attendance.colorCode
                
                
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        // Initialization code
        
        super.awakeFromNib()
        
        foregroundView.layer.cornerRadius = 15
        foregroundView.layer.masksToBounds = true
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.25, 0.35]
        return durations[itemIndex]
    }
    
}


