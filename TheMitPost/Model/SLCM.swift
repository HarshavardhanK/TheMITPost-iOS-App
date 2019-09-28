//
//  SLCM.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 17/03/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import Foundation
import SwiftyJSON

class Attendance {
    
    var totalClasses: String?
    var classesPresent: String?
    var classesAbsent: String?
    var updatedAt: Double?
    
    init(data: JSON?) {
        
        if let _data = data {
            
            totalClasses = _data["totalClasses"].stringValue
            classesAbsent = _data["classesAbsent"].stringValue
            classesPresent = _data["classesAttended"].stringValue
            updatedAt = _data["updatedAt"].doubleValue
            
            if updatedAt == 0.0 {
                updatedAt = -1
            }
            
        }
        
    }
    
    var attendancePercent: Int {
        
        guard let _totClasses = totalClasses else {
            print("problem with _totalClassses")
          return -1
        }
        
        guard let _classesPresent = classesPresent else {
            print("problem with classsesPresent")
            return -1
        }
        
        guard let classesPresentInt = Int(_classesPresent) else {
            print("problem with classsesPresentInt")
            return -1
        }
        
        guard let totalClassesInt = Int(_totClasses) else {
            print("problem with totalClasssesInt")
            return -1
        }
        
       // print("Classes present int convert \(classesPresentInt)")
        
        let percent: Int = Int((Double(classesPresentInt) / Double(totalClassesInt)) * 100)
        
      //  print("Percent \(percent)")
        
        return percent
        
    }
    
    var attendanceUpdatedAt: String {
        
        if let updatedAt_ = updatedAt {
            
            if updatedAt_ == -1 {
                return "__"
            }
        
            let strUpdatedAt = Date.unixTimeStampToDate(unixTime: updatedAt_)
            
            print("\(updatedAt_) -> \(strUpdatedAt)")
            
            return strUpdatedAt
            
        } else {
            return "__"
        }
    }
    
    var attendancePercentString: String {
        
        if attendancePercent == -1 {
            return "NA"
        }
        
        return String(attendancePercent)
    }
    
    var colorCode: UIColor {
        
        if attendancePercent < 75 {
            return UIColor(patternImage: UIImage(named: "red_background_1")!)
        }
        
        return UIColor(patternImage: UIImage(named: "green_gradient")!)
    }

    
}

class Marks {
    
    var sessionalMarks: [String]? = nil
    var assignmentMarks: [String]? = nil
    
    init(data_: JSON?) {
        
        guard let data = data_ else {
            return
        }
        
        if data["status"].boolValue {
            
            if data["is_lab"].boolValue != true {
                
                sessionalMarks = [String](repeating: "NA", count: 2)
                assignmentMarks = [String](repeating: "NA", count: 4)
                
                sessionalMarks?[0] = data["sessional"]["_one"].stringValue
                sessionalMarks?[1] = data["sessional"]["_two"].stringValue
                
                assignmentMarks?[0] = data["assignment"]["_one"].stringValue
                assignmentMarks?[1] = data["assignment"]["_two"].stringValue
                assignmentMarks?[2] = data["assignment"]["_three"].stringValue
                assignmentMarks?[3] = data["assignment"]["_four"].stringValue
                
            }
            
        }
        
        print(data)
        
    }
    
}

class Subject {
    
    var subjectName: String?
    
    var _attendance: Attendance?
    var _marks: Marks?
    
    init(marks: JSON?, attendance: JSON?) {
        
        _marks = Marks(data_: marks)
        _attendance = Attendance(data: attendance)
        
        if let _marks_ = marks {
            subjectName = _marks_["subjectName"].stringValue
        }
        
        if let _attendance = attendance {
            subjectName = _attendance["subjectName"].stringValue
        }
        
    }
    
    func display() {
        print("Subject name \(subjectName!)")
        print("Total classes \(_attendance?.totalClasses!)")
    }
    
}

func groupData(data: JSON) -> [Subject]? {
    
    var subjects = [Subject]()
    
    print(data["attendance"].count)
    
    for i in 0..<data["attendance"].count {
        
        if data["marksStatus"].boolValue && data["attendanceStatus"].boolValue {
            subjects.append(Subject(marks: data["internalMarks"].arrayValue[i], attendance: data["attendance"].arrayValue[i]))
            
        } else if data["attendanceStatus"].boolValue {
            subjects.append(Subject(marks: nil, attendance: data["attendance"].arrayValue[i]))
            
        } else if data["marksStatus"].boolValue {
            subjects.append(Subject(marks: data["marks"].arrayValue[i], attendance: nil))
            
        } else {
            return nil
        }
        
    }
    
    print("Returning grouped subjects data")
    
    return subjects
}
