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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 220
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        if let article_ = article {
            print("Got \(article_.title)")
            retrieveArticle(ID: article_.articleID)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func retrieveArticle(ID: String) {
        
        Alamofire.request(API + ID, method: .get).responseJSON {
            response in
            
            let data = JSON(response.result.value!)
            let contents = data["content"]
            
            for i in 0..<contents.count {
                let content = contents[i]
                
                self.content.append(Article.Content(content: content["content"].stringValue, isImage: content["isImage"].boolValue, isHyperlink: content["isHyperlink"].boolValue))
                
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0) {
            
            let headerView = Bundle.main.loadNibNamed("ArticleHeaderViewTableViewCell", owner: self, options: nil)?.first as! ArticleHeaderViewTableViewCell
            
            if let article_ = article {
                headerView.article = article_
                print("Article assigned to headerView")
            }
            
            return headerView
            
        } else {
            
            if(content[indexPath.row].isImage) {
                
                let imageCell = tableView.dequeueReusableCell(withIdentifier: "contentImageCell") as! ArticleImageTableViewCell
                
                imageCell.content = content[indexPath.row]
                
                return imageCell
                
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! ArticleTableViewCell
        cell.content = content[indexPath.row]

        return cell
        
        
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
