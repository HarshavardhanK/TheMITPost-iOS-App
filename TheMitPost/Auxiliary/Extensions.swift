//
//  Extensions.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 01/02/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
}

extension Date {
    
    static let monthNumber = ["01": "Jan", "02": "Feb", "03": "Mar", "04": "Apr", "05": "May", "06": "June", "07": "Jul", "08": "Aug", "09": "Sep", "10": "Oct", "11": "Nov", "12": "Dec"]
    
    static func unixTimeStampToDate(unixTime: Double) -> String {
        
        let date = Date(timeIntervalSince1970: unixTime / 1000)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        dateFormatter.locale = NSLocale.current
        
        dateFormatter.dateFormat = "dd-MM"
        
        let strDate = dateFormatter.string(from: date)
        
        let day = String(strDate.prefix(2))
        let month = String(strDate.suffix(2))
        
        guard let month_ = monthNumber[month] else {
            print("Could not convert timestamp to time")
            return "__"
        }
        
        return day +  " " + month_
    }
    
    static func noticesDateFromString(strDate: String) -> String {
        
        let _ = String(strDate.prefix(2))
        let day = String(strDate.suffix(2))
        
        let monthIndexStart = strDate.index(strDate.startIndex, offsetBy: 5)
        let monthIndexEnd = strDate.index(monthIndexStart, offsetBy: 2)
        
        let month = String(strDate[monthIndexStart..<monthIndexEnd])
        
        if let month_ = monthNumber[month] {
            return day + " " + month_
            
        } else {
            return ""
        }
    }
    
    static func eventsDateFromString(strDate: String) -> String {
        
        let _ = String(strDate.prefix(2))
        let month = String(strDate.suffix(2))
        
        let dayIndexStart = strDate.index(strDate.startIndex, offsetBy: 5)
        let dayIndexEnd = strDate.index(dayIndexStart, offsetBy: 2)
        
        let day = strDate[dayIndexStart..<dayIndexEnd]
        
        if let month_ = monthNumber[month] {
            return day + " " + month_
            
        } else {
            return ""
        }
        
    }
    
}

extension UIColor {
    
    static var background = UIColor(red: 25.0 / 256.0, green: 30.0 / 256.0, blue: 34.0 / 256.0, alpha: 1.0)
    
    static var foreground = UIColor(red: 36.0 / 256.0, green: 38.0 / 256.0, blue: 40.0 / 256.0, alpha: 0.5)
    
    static var notSoWhite = UIColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0)
}

