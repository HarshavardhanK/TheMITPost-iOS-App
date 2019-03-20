import UIKit
import Alamofire
import SwiftyJSON


var str = "Hello, playground"

let API = "https://api.themitpost.com/posts/"

class Article {
    
    struct Content {
        
        var content: String
        var isURL: Bool
        
        init(content: String, isURL: Bool) {
            self.content = content
            self.isURL = isURL
        }
    }
    
    var articleID: String!
    var title: String?
   // var date: String?
    //var content: Array<String>?
    // var imageURLS: Array<String>?
    var featured_image: String
    var articleLength: Int!
    var content: [Content]?
    
    init(articleID: String, title: String, featured_image: String, content: [Content]) {
        
        self.articleID = articleID
        self.title = title
       // self.date = date
        self.featured_image = featured_image
        self.content = content
        
    }
    
    func display() {
        print(title!)
        print(featured_image)
    }
    
    
}

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
let encodedString = "The Weeknd <em>&#8216;King Of The Fall&#8217;</em>"
let decodedString = String(htmlEncodedString: encodedString)

var articles = [Article]()

func retrieveArticles() {
    
    Alamofire.request(API, method: .get).responseJSON {
        response in
        
        let result = JSON(response.result.value!)
        print(result.count)
        
//        for i in 0...result.count {
//
//            let data = result[i]
//
//            let year = data["date"]["year"].stringValue
//            let month = data["date"]["month"].stringValue
//            let day = data["date"]["day"].stringValue
//
//            let date = day + " " + month + ", " + year
//
//            print(date)
//
//            let article = Article(articleID: data["_id"].stringValue, title: String(htmlEncodedString: data["title"].stringValue)!, featured_image: data["featured_media"].stringValue)
//
//            articles.append(article)
//
//        }
        
        //print(data)
        
        print(result.count)
        
    }
    
}

retrieveArticles()

var contentsList = [Article.Content]()

func retrieveArticle(ID: String) {
    
    Alamofire.request(API + ID, method: .get).responseJSON {
        response in
        
        let data = JSON(response.result.value!)
        let contents = data["content"]
        
        for i in 0..<contents.count {
            let content = contents[i]
            
            contentsList.append(Article.Content(content: content["content"].stringValue, isURL: content["isUrl"].boolValue))
            
        }
    }
    
}

retrieveArticle(ID: "20442")

for content in contentsList {
    print(content.content)
    print(content.isURL)
    print("\n")
}
