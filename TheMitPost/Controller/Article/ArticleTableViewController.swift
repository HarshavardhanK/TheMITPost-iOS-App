//
//  ArticleTableViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 21/03/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleTableViewController: UITableViewController {
    
    let API = "https://api.themitpost.com/posts/"
    
    var article: Article?
    var content = [Article.Content]()
    
    var totalWords: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 220
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        swipeLeft.direction = .right
        
        self.view.addGestureRecognizer(swipeLeft)
        
        if let article_ = article {
            print("Got \(article_.title)")
            retrieveArticle(ID: article_.articleID)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    var cellIsAnimated = [Bool]()
    
    func retrieveArticle(ID: String) {
        
        Alamofire.request(API + ID, method: .get).responseJSON {
            response in
            
            let data = JSON(response.result.value!)
            let contents = data["content"]
            
            for i in 0...contents.count {
                let content = contents[i]
                
                
                let paragraph = String(htmlEncodedString: content["content"].stringValue)
                var components = paragraph!.components(separatedBy: .whitespacesAndNewlines)
                components = components.filter{!$0.isEmpty}
                self.totalWords += components.count
                
                self.content.append(Article.Content(content: paragraph!, isImage: content["isImage"].boolValue, isHyperlink: content["isHyperlink"].boolValue))
                
                self.cellIsAnimated = [Bool](repeating: false, count: self.content.count)
                
            }
            
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("TableView size \(content.count)")
        return content.count
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = Bundle.main.loadNibNamed("ArticleHeaderViewTableViewCell", owner: self, options: nil)?.first as! ArticleHeaderViewTableViewCell
//
//        if let article_ = article {
//            headerView.article = article_
//            print("Article assigned to headerView")
//        }
//
//        return headerView
//
//
//    }
    
    let offset = 2

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == 0) {
            let timeDateCell = tableView.dequeueReusableCell(withIdentifier: "timeDateCell") as! ArticleTimeDateViewCell
            
            timeDateCell.time = "\(totalWords / 225) min read"
            timeDateCell.date = article?.date
            
            timeDateCell.selectionStyle = .none
            
            return timeDateCell
            
        } else if indexPath.row == 1 {
            let headerView = Bundle.main.loadNibNamed("ArticleHeaderViewTableViewCell", owner: self, options: nil)?.first as! ArticleHeaderViewTableViewCell
            
            if let article_ = article {
                headerView.article = article_
                print("Article assigned to headerView")
            }
            
            return headerView
            
        } else {
            
            if(content[indexPath.row - offset].isImage) {
                
                let imageCell = tableView.dequeueReusableCell(withIdentifier: "contentImageCell") as! ArticleImageTableViewCell
                
                imageCell.content = content[indexPath.row - offset]
                
                imageCell.selectionStyle = .none
                
                return imageCell
                
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! ArticleTableViewCell
        cell.content = content[indexPath.row - offset]
        
        print(content[indexPath.row - offset])
        
        cell.paragraphNumber = indexPath.row - 2
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !cellIsAnimated[indexPath.row] {
            
            if(indexPath.row == 1) {
                
                let transform = CATransform3DTranslate(CATransform3DIdentity, -50, 100, 0)
                cell.layer.transform = transform
                cell.alpha = 0.0
                
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                    
                    // transform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 2)
                    cell.layer.transform = CATransform3DIdentity
                    cell.alpha = 1.0
                    
                }) { (true) in
                    print("Animation complete")
                }
                
            }
            
            if(indexPath.row >= 2) {
                
                if !content[indexPath.row - 2].isImage {
                    cell.alpha = 0.3
                    
                    UIView.animate(withDuration: 2.5, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                        cell.alpha = 1.0
                    }, completion: nil)
                    
                } else if content[indexPath.row - 2].isImage {
                    
                    let transform = CATransform3DTranslate(CATransform3DIdentity, 50, -10, 0)
                    cell.layer.transform = transform
                    cell.alpha = 0.0
                    
                    UIView.animate(withDuration: 1.5, delay: 0.0, options:[.curveEaseOut, .allowUserInteraction], animations: {
                        cell.layer.transform = CATransform3DIdentity
                        cell.alpha = 1.0
                        
                    }, completion: nil)
                    
                }
            }
            
            cellIsAnimated[indexPath.row] = true
            
        }
        
        
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return CGFloat(225)
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
