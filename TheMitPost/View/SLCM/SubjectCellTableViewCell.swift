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
    
    @IBOutlet weak var slcmForegroundView: RotatedView!
    @IBOutlet weak var absent: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var present: UILabel!
    
    
    @IBOutlet weak var totalContainerView: UIView!
    @IBOutlet weak var secondContainerView: RotatedView!
    
    @IBOutlet weak var thirdContainerView: RotatedView!
    
    @IBOutlet weak var bottomContainerView: RotatedView!
    
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
    
    @IBOutlet weak var line: UIView!
    
    
    func mode() {
        
         backgroundColor = .systemBackground

        if traitCollection.userInterfaceStyle == .dark {
           
            subjectName.backgroundColor = .darkGray
            absent.backgroundColor = .darkGray
            present.backgroundColor = .darkGray
            slcmForegroundView.backgroundColor = .darkGray
            
            attendancePercentage.backgroundColor = .darkGray
            
            absent.textColor = .label
            present.textColor = .label
            
            attendancePercentage.textColor = .label
            attendancePercentage2.textColor = .label
            
            totalClasses.textColor = .label
            bunks.textColor = .label
            
            totalContainerView.backgroundColor = .darkGray
            secondContainerView.backgroundColor = .darkGray
            thirdContainerView.backgroundColor = .darkGray
            bottomContainerView.backgroundColor = .darkGray
            
            assignment1.backgroundColor = .darkGray
            assignment2.backgroundColor = .darkGray
            assignment3.backgroundColor = .darkGray
            assignment4.backgroundColor = .darkGray
            
            sessional1.backgroundColor = .darkGray
            sessional2.backgroundColor = .darkGray
            
            assignment1.textColor = .secondaryLabel
            assignment2.textColor = .secondaryLabel
            assignment3.textColor = .secondaryLabel
            assignment4.textColor = .secondaryLabel
            
            sessional1.textColor = .secondaryLabel
            sessional2.textColor = .secondaryLabel
            
        } else {
            
            subjectName.backgroundColor = .white
            absent.backgroundColor = .white
            present.backgroundColor = .white
            slcmForegroundView.backgroundColor = .white
            
            attendancePercentage.backgroundColor = .white
            
            absent.textColor = .label
            present.textColor = .label
            
            attendancePercentage.textColor = .label
            attendancePercentage2.textColor = .label
            
            totalClasses.textColor = .label
            bunks.textColor = .label
            
            totalContainerView.backgroundColor = .darkGray
            
            secondContainerView.backgroundColor = .white
            thirdContainerView.backgroundColor = .white
            bottomContainerView.backgroundColor = .white
            
            assignment1.backgroundColor = .white
            assignment2.backgroundColor = .white
            assignment3.backgroundColor = .white
            assignment4.backgroundColor = .white
            
            sessional1.backgroundColor = .white
            sessional2.backgroundColor = .white
            
            assignment1.textColor = .secondaryLabel
            assignment2.textColor = .secondaryLabel
            assignment3.textColor = .secondaryLabel
            assignment4.textColor = .secondaryLabel
            
            sessional1.textColor = .secondaryLabel
            sessional2.textColor = .secondaryLabel
            
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        mode()
        
        
    }
    
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
                
                if let s2 = _subject._marks?.sessionalMarks?[1] {
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
                total.text = attendance.totalClasses
                
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
        
        mode()
        
        foregroundView.layer.cornerRadius = 15
        foregroundView.layer.masksToBounds = true
        
        //backgroundColor = .systemBackground
        
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


