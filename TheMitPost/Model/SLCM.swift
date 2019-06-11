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

    var subjectCode = "Not available"
    var subjectName = "Not available"

    var totalClassPresent: String?
    var totalAbsent: String?
    var attendancePercent: Double?
    
    var attendancePercent_string: String {
        
        get {
            
            if let attendance = attendancePercent {
                return String(attendance)
                
            } else {
                return ERROR_CODES.NOT_AVAILABLE
            }
            
        }
        
    }
    
    var colorCodeForAttendance: UIColor {
        
        get {
            
            guard let attendance_percentage = attendancePercent else {
                 return UIColor.white
            }
            
            if attendance_percentage <= 75.0 {
                return UIColor.red
            }
            
            if attendance_percentage > 75.0 && attendance_percentage <= 85.0 {
                return UIColor.orange
            }
            
            if attendance_percentage > 85.0 {
                return UIColor.green
            }
        }
    }
    

    init(data: JSON) {

        subjectName = data["subjectName"].stringValue
        subjectCode = data["subjectCode"].stringValue
        totalClassPresent = data["totalClassPresent"].stringValue
        totalAbsent = data["totalAbsent"].stringValue
        attendancePercent = data["attendancePercent"].doubleValue
        
        print("Attendance Successfully initialized..")
        
        print(subjectCode)

    }
    
    func description() -> String {
        return "Attendance :: Subject code \(subjectCode) | Subject name \(subjectName)"
    }

}

class Marks {


    var subjectCode: String
    var subjectName: String

    var totalSessionalMarks: String
    var totalAssignmentMarks: String

    var sessionalMarks = [String]()
    var assignmentMarks = [String]()

    init(data: JSON) {
        
        print(data)

        subjectCode = data["subjectCode"].stringValue
        subjectName = data["subjectName"].stringValue

        
        if data["assignmentStatus"].boolValue {
            
            totalAssignmentMarks = data["totalAssignemntMarks"].stringValue
            assignmentMarks.append(data["assignmentMarks"]["assignment1"].stringValue)
            assignmentMarks.append(data["assignmentMarks"]["assignment2"].stringValue)
            assignmentMarks.append(data["assignmentMarks"]["assignment3"].stringValue)
            assignmentMarks.append(data["assignmentMarks"]["assignment4"].stringValue)
            
        } else {
            
            assignmentMarks = Array(repeating: ERROR_CODES.NOT_AVAILABLE, count: 4)
            totalAssignmentMarks = ERROR_CODES.NOT_AVAILABLE
        }
        
        if data["sessStatus"].boolValue {
            
            sessionalMarks.append(data["sessionalMarks"]["sessional1"].stringValue)
            sessionalMarks.append(data["sessionalMarks"]["sessional2"].stringValue)
            totalSessionalMarks = data["totalSessionalMarks"].stringValue
            
        } else {
            
            sessionalMarks = Array(repeating: ERROR_CODES.NOT_AVAILABLE, count: 2)
            totalSessionalMarks = ERROR_CODES.NOT_AVAILABLE
        }

        print("Marks Succesfully initialized object")
        
        print(subjectCode)

    }
    
    func description() -> String {
        return "MARKS :: Subject code \(String(describing: subjectCode)) | Subject name \(String(describing: subjectName))"
    }

}

class Subject {

    var marks: Marks?
    var attendance: Attendance?
    
    var subjectName: String {
        get {
            
            if let _marks = marks {
                return _marks.subjectName
            } else {
                return ERROR_CODES.NOT_AVAILABLE
            }
        }
    }
    
    var subjectCode: String {
        
        get {
            
            if let _marks = marks {
                return _marks.subjectCode
            } else {
                return ERROR_CODES.NOT_AVAILABLE
            }
        }
    }

    init(marks: Marks, attendance: Attendance) {
        
        self.marks = marks
        self.attendance = attendance
        
    }
    
    func display() {
        print("Subject name: \(marks?.subjectName ?? "Name not available")")
        print("Subject code: \(attendance?.subjectCode ?? "Code not available")")
    }
    
    static func segragateMarksAndAttendance(data: JSON) -> [Subject] {
        
        var subjects = [Subject]()
        let length = data["marks"].count
        
        for i in 0..<length {
            
            let subject = Subject(marks: Marks(data: data["marks"].array![i]), attendance: Attendance(data: data["attendance"].array![i]))
            
            subjects.append(subject)
        }
        
        return subjects
        
    }
    

}

//MARK:- Format SLCM Data methods

/*
 
 An array of Subject objects having all its Marks and Attendance objects initialized and filled with data
 
 */


