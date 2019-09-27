import UIKit
var str = "Hello, playground"


let unixTimestamp = 1440134638.0
let date = Date(timeIntervalSince1970: unixTimestamp)
let dateFormatter = DateFormatter()
dateFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
dateFormatter.locale = NSLocale.current
dateFormatter.dateFormat = "dd-MM" //Specify your format that you want
let strDate = dateFormatter.string(from: date)
print(strDate)

func unixTimeStampToDate(unixTime: Double) -> String {
    
    let monthNumber = ["01": "Jan", "02": "Feb", "03": "Mar", "04": "Apr", "05": "May", "06": "June", "07": "Jul", "08": "Aug", "09": "Sep", "10": "Oct", "11": "Nov", "12": "Dec"]
    
    let date = Date(timeIntervalSince1970: unixTime)
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeZone = TimeZone(abbreviation: "IST")
    dateFormatter.locale = NSLocale.current
    
    dateFormatter.dateFormat = "dd-MM"
    
    let strDate = dateFormatter.string(from: date)
    
    let day = String(strDate.prefix(2))
    let month = String(strDate.suffix(2))
    
    guard let month_ = monthNumber[month] else {
        return "__"
    }
    
    return day +  " " + month_
}


print(unixTimeStampToDate(unixTime: 1440134638.0))
