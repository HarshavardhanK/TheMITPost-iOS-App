import UIKit


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
    
    
    static func dateString(strDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        dateFormatter.locale = NSLocale.current
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: strDate) {
            return date.day + " " + String(date.month.prefix(3))
        }
        
        return "NA"
        
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
}

print(Date.dateString(strDate: "2019-7-10"))
