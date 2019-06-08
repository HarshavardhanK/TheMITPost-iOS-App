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

    var totalClassPresent = 0
    var totalAbsent = 0
    var attendancePercent = 0.0

    init(data: JSON) {

        subjectName = data["subjectName"].stringValue
        subjectCode = data["subjectCode"].stringValue
        totalClassPresent = data["totalClassPresent"].intValue
        totalAbsent = data["totalAbsent"].intValue
        attendancePercent = data["attendancePercent"].doubleValue
        
        print("Attendance Successfully initialized..")
        
        print(subjectCode)

    }
    
    func description() -> String {
        return "Attendance :: Subject code \(subjectCode) | Subject name \(subjectName)"
    }

}

class Marks {


    var subjectCode: String = " "
    var subjectName: String = " "

    var totalSessionalMarks: Double = 0.0
    var totalAssignmentMarks: Double = 0.0

    var sessionalMarks = [Double]()
    var assignmentMarks = [Double]()

    init(data: JSON) {
        
        print(data)

        subjectCode = data["subjectCode"].stringValue
        subjectName = data["subjectName"].stringValue

        
        if data["assignmentStatus"].boolValue {
            
            totalAssignmentMarks = data["totalAssignemntMarks"].doubleValue
            assignmentMarks.append(data["assignmentMarks"]["assignment1"].doubleValue)
            assignmentMarks.append(data["assignmentMarks"]["assignment2"].doubleValue)
            assignmentMarks.append(data["assignmentMarks"]["assignment3"].doubleValue)
            assignmentMarks.append(data["assignmentMarks"]["assignment4"].doubleValue)
            
        }
        
        if data["sessStatus"].boolValue {
            
            sessionalMarks.append(data["sessionalMarks"]["sessional1"].doubleValue)
            sessionalMarks.append(data["sessionalMarks"]["sessional2"].doubleValue)
            totalSessionalMarks = data["totalSessionalMarks"].doubleValue
            
        }


        print("Marks Succesfully initialized object")
        
        print(subjectCode)

    }
    
    func description() -> String {
        return "MARKS :: Subject code \(subjectCode) | Subject name \(subjectName)"
    }

}

class Subject {

    var marks: Marks?
    var attendance: Attendance?
    
    var subjectName: String = ""
    var subjectCode: String = ""

    init(marks: Marks, attendance: Attendance) {
        
        self.marks = marks
        self.attendance = attendance
        
        if let _subjectName = self.marks?.subjectName {
            self.subjectName = _subjectName
        }
        
        if let _subjectCode = self.attendance?.subjectCode {
            self.subjectCode = _subjectCode
        }
        
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


