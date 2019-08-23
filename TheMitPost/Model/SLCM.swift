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
    
    init(data: JSON?) {
        
        if let _data = data {
            
            print(_data)
            
            totalClasses = _data["totalClasses"].stringValue
            classesAbsent = _data["classesAbsent"].stringValue
            classesPresent = _data["classesPresent"].stringValue
            
        }
        
    }
    
    var attendancePercent: Int {
        return 80
    }
    
    var attendancePercentString: String {
        return String(attendancePercent)
    }
    
    var colorCode: UIColor {
        
        if attendancePercent < 75 {
            return UIColor.red
        }
        
        return UIColor.green
    }

    
}

class Marks {
    
    var sessionalMarks: [String]?
    var assignmentMarks: [String]?
    
    init(data: JSON?) {
        
        guard let _data_ = data else {
            
            sessionalMarks = nil
            assignmentMarks = nil
            //above is quite implicit
            
            return
        }
        
        print(_data_)
        
        //set up code to handle assignment marks and sessional marks
        
        
    }
    
}

class Subject {
    
    var subjectName: String?
    
    var _attendance: Attendance?
    var _marks: Marks?
    
    init(marks: JSON?, attendance: JSON?) {
        
        _marks = Marks(data: marks)
        _attendance = Attendance(data: attendance)
        
        if let _marks_ = marks {
            subjectName = _marks_["subjectName"].stringValue
        }
        
        if let _attendance = attendance {
            subjectName = _attendance["subjectName"].stringValue
        }
        
    }
    
    func display() {
        print("Subject name \(subjectName)")
        print("Total classes \(_attendance?.totalClasses)")
    }
    
}

func groupData(data: JSON) -> [Subject]? {
    
    var subjects = [Subject]()
    
    print(data["attendance"].count)
   // print(data["attendance"])
    
    for i in 0..<data["attendance"].count {
        
        if data["marksStatus"].boolValue && data["attendance"].boolValue {
            subjects.append(Subject(marks: data["attendance"].arrayValue[i], attendance: data["marks"].arrayValue[i]))
            
        } else if data["attendanceStatus"].boolValue {
            print("Attendance exists")
            print(data["attendance"].arrayValue[i])
            subjects.append(Subject(marks: nil, attendance: data["attendance"].arrayValue[i]))
            
        } else if data["marksStatus"].boolValue {
            subjects.append(Subject(marks: data["marks"].arrayValue[i], attendance: nil))
            
        } else {
            //subjects?.append(Subject(marks: nil, attendance: nil))
            return nil
        }
        
    }
    
    return subjects
}
