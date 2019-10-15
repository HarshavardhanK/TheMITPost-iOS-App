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
    
    @IBOutlet weak var slcmHeaderImage: UIImageView!
    @IBOutlet weak var slcmForegroundView: RotatedView!
    @IBOutlet weak var absent: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var present: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    
    
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
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var line: UIView!
    
    //MARK: ASSMT SESS LABELS
    @IBOutlet var assmnt12Label: UILabel!
    @IBOutlet var assmnt34Label: UILabel!
    
    @IBOutlet var sess1Label: UILabel!
    @IBOutlet var sess2Label: UILabel!
    
    
    func mode() {
        
        if #available(iOS 13, *) {
            
            timeLabel.textColor = .background

                if traitCollection.userInterfaceStyle == .dark {
            
                    backgroundColor = .background
                    subjectName.backgroundColor = .foreground
                    absent.backgroundColor = .foreground
                    present.backgroundColor = .foreground
                    slcmForegroundView.backgroundColor = .foreground
                    
                    attendancePercentage.backgroundColor = .foreground
                    
                    absent.textColor = .label
                    present.textColor = .label
                    
                    attendancePercentage.textColor = .label
                    attendancePercentage2.textColor = .label
                    
                    totalClasses.textColor = .label
                    bunks.textColor = .label
                    
                    totalContainerView.backgroundColor = .foreground
                    secondContainerView.backgroundColor = .foreground
                    thirdContainerView.backgroundColor = .foreground
                    bottomContainerView.backgroundColor = .foreground
                    
                    assignment1.backgroundColor = .foreground
                    assignment2.backgroundColor = .foreground
                    assignment3.backgroundColor = .foreground
                    assignment4.backgroundColor = .foreground
                    
                    sessional1.backgroundColor = .foreground
                    sessional2.backgroundColor = .foreground
                    
                    assignment1.textColor = .secondaryLabel
                    assignment2.textColor = .secondaryLabel
                    assignment3.textColor = .secondaryLabel
                    assignment4.textColor = .secondaryLabel
                    
                    sessional1.textColor = .secondaryLabel
                    sessional2.textColor = .secondaryLabel
                    
                } else {
                    
                    backgroundColor = .white
                    subjectName.backgroundColor = .notSoWhite
                    absent.backgroundColor = .notSoWhite
                    present.backgroundColor = .notSoWhite
                    slcmForegroundView.backgroundColor = .notSoWhite
                    
                    attendancePercentage.backgroundColor = .notSoWhite
                    
                    absent.textColor = .label
                    present.textColor = .label
                    
                    attendancePercentage.textColor = .label
                    attendancePercentage2.textColor = .label
                    
                    totalClasses.textColor = .label
                    bunks.textColor = .label
                    
                    totalContainerView.backgroundColor = .notSoWhite
                    
                    secondContainerView.backgroundColor = .notSoWhite
                    thirdContainerView.backgroundColor = .notSoWhite
                    bottomContainerView.backgroundColor = .notSoWhite
                    
                    assignment1.backgroundColor = .notSoWhite
                    assignment2.backgroundColor = .notSoWhite
                    assignment3.backgroundColor = .notSoWhite
                    assignment4.backgroundColor = .notSoWhite
                    
                    sessional1.backgroundColor = .notSoWhite
                    sessional2.backgroundColor = .notSoWhite
                    
                    assignment1.textColor = .secondaryLabel
                    assignment2.textColor = .secondaryLabel
                    assignment3.textColor = .secondaryLabel
                    assignment4.textColor = .secondaryLabel
                    
                    sessional1.textColor = .secondaryLabel
                    sessional2.textColor = .secondaryLabel
                    
                    assmnt12Label.textColor = .secondaryLabel
                    assmnt34Label.textColor = .secondaryLabel
                    sess1Label.textColor = .secondaryLabel
                    sess2Label.textColor = .secondaryLabel
                    
                }
            
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        mode()
        
        
    }
    
    var subject: Subject? {
        
        didSet {
            
            if let _subject = subject {
                
                let images = ["slcm5", "slcm6", "slcm7", "slcm8", "slcm9", "slcm10"]
                let name = images[Int(arc4random()) % images.count]
                
                slcmHeaderImage.image = UIImage(named: name)
                
                subjectName.text = _subject.subjectName
                detailLabel.text = _subject.subjectName
                
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
                
                timeLabel.text = attendance.attendanceUpdatedAt
                
                //MARK: Handle Lab Marks
                
                if let lab = _subject._marks?.isLab {
                    
                    if lab {
                        assmnt12Label.text = "Labs support soon"
                        assmnt34Label.text = "Labs support soon"
                        sess1Label.text = "Labs support soon"
                        sess2Label.text = "Labs support soon"
                        
                    } else {
                        assmnt12Label.text = "ASSIGNMENT 1-2"
                        assmnt34Label.text = "ASSIGNMENT 3-4"
                        sess1Label.text = "SESSIONAL 1"
                        sess2Label.text = "SESSIONAL 2"
                    }
                    
                }
            }
            
        }
        
    }
    
    
    override func awakeFromNib() {
        // Initialization code
        
        super.awakeFromNib()
        
        mode()
        
        totalContainerView.layer.cornerRadius = 15
        layer.cornerRadius = 15
        foregroundView.layer.cornerRadius = 15
        foregroundView.layer.masksToBounds = true
        
        subjectName.numberOfLines = 0
        subjectName.lineBreakMode = .byWordWrapping
        
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


